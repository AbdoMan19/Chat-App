import 'dart:developer';

import 'package:chato/authentication/presentation/controllers/providers/authentication_sign_in_with_phone_proivder.dart';
import 'package:chato/authentication/presentation/controllers/providers/authentication_verify_number_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chato/authentication/domain/use_cases/authentication_get_user_use_case.dart';
import 'package:chato/authentication/domain/use_cases/authentication_sign_in_with_google_use_case.dart';
import 'package:chato/authentication/presentation/controllers/providers/authentication_get_user_provider.dart';
import 'package:chato/authentication/presentation/controllers/providers/authentication_sign_in_provider.dart';
import 'package:chato/authentication/presentation/controllers/providers/authentication_sign_in_with_google_provider.dart';
import 'package:chato/authentication/presentation/controllers/providers/authentication_sign_out_provider.dart';
import 'package:chato/authentication/presentation/controllers/providers/authentication_sign_up_provider.dart';

import '../../domain/entities/user.dart';
import '../../domain/use_cases/authentication_sign_in_use_case.dart';
import '../../domain/use_cases/authentication_sign_in_with_phone_use_case.dart';
import '../../domain/use_cases/authentication_sign_out_use_case.dart';
import '../../domain/use_cases/authentication_sign_up_use_case.dart';
import '../../domain/use_cases/authentication_verify_number_use_case.dart';

class AuthenticationState {
  final User? user;
  final bool isLoading;
  final Exception? exception;

  AuthenticationState({this.user, this.isLoading = false, this.exception});
}

class AuthenticationController extends StateNotifier<AuthenticationState> {
  final AuthenticationSignInUseCase authenticationSignInUseCase;
  final AuthenticationSignUpUseCase authenticationSignUpUseCase;
  final AuthenticationSignOutUseCase authenticationSignOutUseCase;
  final AuthenticationGetUserUseCase authenticationGetUserUseCase;
  final AuthenticationSignInWithGoogleUseCase
      authenticationSignInWithGoogleUseCase;
  final AuthenticationSignInWithPhoneUseCase authenticationSignInWithPhoneUseCase;
  final AuthenticationVerifyNumberUseCase authenticationVerifyNumberUseCase;

  AuthenticationController({
    required this.authenticationSignInUseCase,
    required this.authenticationSignUpUseCase,
    required this.authenticationSignOutUseCase,
    required this.authenticationGetUserUseCase,
    required this.authenticationSignInWithGoogleUseCase,
    required this.authenticationSignInWithPhoneUseCase,
    required this.authenticationVerifyNumberUseCase,
    re
  }) : super(AuthenticationState());

  Future<void> signIn(String email, String password) async {
    state = AuthenticationState(isLoading: true);
    try {
      final user = await authenticationSignInUseCase
          .execute(AuthenticationSignInUseCaseParams(email, password));
      state = AuthenticationState(user: user);
    } on Exception catch (e, _) {
      state = AuthenticationState(exception: e);
    }
  }

  Future<void> signInWithGoogle() async {
    state = AuthenticationState(isLoading: true);
    try {
      final user = await authenticationSignInWithGoogleUseCase.execute(null);
      state = AuthenticationState(user: user);
    } on Exception catch (e, _) {
      state = AuthenticationState(exception: e);
    }
  }

  Future<String?> signInWithPhone(String phone) async {
    state = AuthenticationState(isLoading: true);
    try {
      String? result =  await authenticationSignInWithPhoneUseCase.execute(phone);
      state = AuthenticationState();
      return result;
    } on Exception catch (e, _) {
      state = AuthenticationState(exception: e);
    }
    return null;
  }

  Future<void> verifyPhoneNumber(String verificationId, String smsCode) async {
    state = AuthenticationState(isLoading: true);
    try {
      final user = await authenticationVerifyNumberUseCase.execute(AuthenticationVerifyNumberUseCaseParams(verificationId, smsCode));
      state = AuthenticationState(user: user);
    } on Exception catch (e, _) {
      state = AuthenticationState(exception: e);
    }
  }

  Future<void> signUp(String username, String email, String password) async {
    state = AuthenticationState(isLoading: true);
    try {
      final user = await authenticationSignUpUseCase.execute(
          AuthenticationSignUpUseCaseParams(username, email, password));
      state = AuthenticationState(user: user);
    } on Exception catch (e, _) {
      state = AuthenticationState(exception: e);
    }
  }

  Future<void> getCurrentUser() async {
    state = AuthenticationState(isLoading: true);
    try {
      final user = await authenticationGetUserUseCase.execute(null);
      state = AuthenticationState(user: user);
    } on Exception catch (e, _) {
      state = AuthenticationState(exception: e);
    }
  }

  Future<void> signOut() async {
    state = AuthenticationState(isLoading: true);
    try {
      await authenticationSignOutUseCase.execute(null);
      state = AuthenticationState();
    } on Exception catch (e, _) {
      state = AuthenticationState(exception: e);
    }
  }
}

final authenticationControllerProvider =
    StateNotifierProvider<AuthenticationController, AuthenticationState>(
  (ref) {
    return AuthenticationController(
      authenticationSignInWithGoogleUseCase:
          ref.watch(authenticationSignInWithGoogleProvider),
      authenticationSignInUseCase: ref.watch(authenticationSignInProvider),
      authenticationSignUpUseCase: ref.watch(authenticationSignUpProvider),
      authenticationSignOutUseCase: ref.watch(authenticationSignOutProvider),
      authenticationGetUserUseCase: ref.watch(authenticationGetUserProvider),
      authenticationSignInWithPhoneUseCase:
          ref.watch(authenticationSignInWithPhoneProvider),
      authenticationVerifyNumberUseCase: ref.watch(authenticationVerifyNumberProvider),
    );
  },
);
