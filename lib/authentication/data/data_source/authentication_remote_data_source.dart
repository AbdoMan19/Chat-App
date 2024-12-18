import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

abstract class BaseAuthenticationRemoteDataSource {
  Future<UserModel?> signIn(String email, String password);

  Future<UserModel?> signUp(String username, String email, String password);
  Future<void> signOut();
  Future<UserModel?> signInWithGoogle();
  Future<String?> signInWithPhoneNumber(String phoneNumber);
  Future<UserModel?> verifyPhoneNumber(String verificationId, String smsCode);
  Future<UserModel?> getCurrentUser();
}

class AuthenticationRemoteDataSource
    implements BaseAuthenticationRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthenticationRemoteDataSource(this.firebaseAuth, this.googleSignIn);

  Future<void> saveFcmToken(String userId) async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await FirebaseFirestore.instance
          .collection('fcmTokens')
          .doc(userId)
          .set({'token': token});
    }
  }

  Future<void> removeFcmToken(String userId) async {
    await FirebaseFirestore.instance
        .collection('fcmTokens')
        .doc(userId)
        .delete();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser != null) {
        return UserModel.fromFirebaseUser(currentUser);
      }
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<UserModel?> signIn(String email, String password) async {
    try {
      final signInResult = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (signInResult.user != null) {
        await saveFcmToken(signInResult.user!.uid);
        return UserModel.fromFirebaseUser(signInResult.user!);
      }
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser != null) {
        await removeFcmToken(currentUser.uid);
      }
      await firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<UserModel?> signUp(
      String username, String email, String password) async {
    try {
      final signUpResult = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? updatedUser = signUpResult.user;
      if (updatedUser != null) {
        await updatedUser.updateDisplayName(username);
        await updatedUser.reload();
        await saveFcmToken(updatedUser.uid);
        updatedUser = firebaseAuth.currentUser;
      }
      return updatedUser != null
          ? UserModel.fromFirebaseUser(updatedUser)
          : null;
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      final googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        return null;
      }
      final googleSignInAuthentication = await googleSignInAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final signInResult = await firebaseAuth.signInWithCredential(credential);
      if (signInResult.user != null) {
        await saveFcmToken(signInResult.user!.uid);
        return UserModel.fromFirebaseUser(signInResult.user!);
      }
      return null;
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  @override
  Future<String?> signInWithPhoneNumber(String phoneNumber) async {
    try {
      final verificationId = await sendOtp(phoneNumber);
      return verificationId;
    } catch (e) {
      log('Sign-in with phone number failed: $e');
      return null;
    }
  }

  @override
  Future<UserModel?> verifyPhoneNumber(String verificationId, String smsCode) async {
    log('Verifying OTP' + verificationId + smsCode);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCredential = await firebaseAuth.signInWithCredential(credential);
      if (userCredential.user != null) {
        await saveFcmToken(userCredential.user!.uid);
        return UserModel.fromFirebaseUser(userCredential.user!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }

  Future<String?> sendOtp(String phoneNumber) async {
    final completer = Completer<String?>();

    verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
      await firebaseAuth.signInWithCredential(phoneAuthCredential);
    }

    verificationFailed(FirebaseAuthException authException) {
      log('Phone verification failed: $authException');
      completer.completeError(authException); // Complete with an error.
    }

    codeSent(String verificationId, int? resendToken) async {
      log('Verification code sent to number: $phoneNumber');
      completer.complete(verificationId); // Complete with the verificationId.
    }

    codeAutoRetrievalTimeout(String verificationId) {
      log('Auto retrieval timeout');
    }

    try {
      log('Sending OTP to number: $phoneNumber');
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+20 12 70953626",
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
      return completer.future;
    } catch (e) {
      log('Failed to send OTP: $e');
      return null;
    }
  }

}
