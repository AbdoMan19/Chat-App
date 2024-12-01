import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/user_model.dart';

abstract class BaseAuthenticationRemoteDataSource {
  Future<UserModel?> signIn(String email, String password);

  Future<UserModel?> signUp(String username, String email, String password);

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();
}

class AuthenticationRemoteDataSource
    implements BaseAuthenticationRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthenticationRemoteDataSource(this.firebaseAuth);

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
}
