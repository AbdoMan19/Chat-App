import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> saveUser(UserModel user) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('userId', user.uuid);
    await sharedPreferences.setString('username', user.name);
    await sharedPreferences.setString('email', user.email ?? '');
  }

  Future<UserModel?> getUser() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userId = sharedPreferences.getString('userId');
    final username = sharedPreferences.getString('username');
    final email = sharedPreferences.getString('email');
    if (userId != null && username != null) {
      return UserModel(
        uuid: userId,
        name: username,
        email: email == '' ? null : email,
      );
    }
    return null;
  }

  Future<void> removeUser() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove('userId');
    await sharedPreferences.remove('username');
    await sharedPreferences.remove('email');
  }

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

  Future<bool> checkFirstTimeLogged() async {
    final fireStore = FirebaseFirestore.instance.collection("isUserFirstTime").doc(firebaseAuth.currentUser!.uid);
    final doc = await fireStore.get();
    if(!doc.exists){
      log("First time logged");
      return true;
    }
    log("Not first time logged");
    return false;
  }

  Future<void> setFirstTimeLogged() async {
    final fireStore = FirebaseFirestore.instance.collection("isUserFirstTime").doc(firebaseAuth.currentUser!.uid);
    await fireStore.set({"first_time": true});
  }

  Future<void> sentFirstTimeLoggedAnalytics(String userId) async {
    await FirebaseAnalytics.instance.logEvent(
      name: "first_time_login",
      parameters: {
        "user_id": userId,
      },
    );
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser != null) {
        await saveFcmToken(currentUser.uid);
        return UserModel.fromFirebaseUser(currentUser);
      }else{
        final savedUser = await getUser();
        if (savedUser != null) {
          await saveFcmToken(savedUser.uuid);
          return savedUser;
        }
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
        await saveUser(UserModel.fromFirebaseUser(signInResult.user!));
        if(await checkFirstTimeLogged()){
          await sentFirstTimeLoggedAnalytics(signInResult.user!.uid);
          await setFirstTimeLogged();
        }
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
        await removeUser();
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
      if (updatedUser != null) {
        await saveUser(UserModel.fromFirebaseUser(updatedUser));
        if(await checkFirstTimeLogged()){
          await sentFirstTimeLoggedAnalytics(updatedUser.uid);
          await setFirstTimeLogged();
        }
        return UserModel.fromFirebaseUser(updatedUser);
      }
      return null;
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
        await saveUser(UserModel.fromFirebaseUser(signInResult.user!));
        if(await checkFirstTimeLogged()){
          await sentFirstTimeLoggedAnalytics(signInResult.user!.uid);
          await setFirstTimeLogged();
        }
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
    log('Verifying OTP$verificationId$smsCode');
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCredential = await firebaseAuth.signInWithCredential(credential);
      log('UserCredential: ${userCredential.user}${userCredential.user!.uid}');
      if(userCredential.user != null) {
        await saveFcmToken(userCredential.user!.uid);
        await saveUser(UserModel.fromFirebaseUser(userCredential.user!));
        if(await checkFirstTimeLogged()){
          await sentFirstTimeLoggedAnalytics(userCredential.user!.uid);
          await setFirstTimeLogged();
        }
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
