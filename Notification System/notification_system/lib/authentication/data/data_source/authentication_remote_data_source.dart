import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

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
