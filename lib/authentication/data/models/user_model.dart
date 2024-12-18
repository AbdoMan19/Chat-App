import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user.dart' as entity;

class UserModel extends entity.User {
  UserModel({required super.uuid, required super.email, required super.name});

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uuid: user.uid,
      email: user.email == null ? "" : user.email!,
      name: user.displayName == null ? user.phoneNumber! : user.displayName!,
    );
  }
  
  @override
  String toString() {
    return 'UserModel(uuid: $uuid, email: $email, name: $name)';
  }
}
