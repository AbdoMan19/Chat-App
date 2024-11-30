import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification_system/authentication/domain/use_cases/authentication_get_user_use_case.dart';
import 'package:notification_system/authentication/presentation/controllers/providers/authentication_get_user_provider.dart';
import 'package:notification_system/authentication/presentation/controllers/providers/authentication_sign_in_provider.dart';
import 'package:notification_system/authentication/presentation/controllers/providers/authentication_sign_out_provider.dart';
import 'package:notification_system/authentication/presentation/controllers/providers/authentication_sign_up_provider.dart';

import '../../domain/entities/user.dart';
import '../../domain/use_cases/authentication_sign_in_use_case.dart';
import '../../domain/use_cases/authentication_sign_out_use_case.dart';
import '../../domain/use_cases/authentication_sign_up_use_case.dart';

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

  AuthenticationController({
    required this.authenticationSignInUseCase,
    required this.authenticationSignUpUseCase,
    required this.authenticationSignOutUseCase,
    required this.authenticationGetUserUseCase,
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
      authenticationSignInUseCase: ref.watch(authenticationSignInProvider),
      authenticationSignUpUseCase: ref.watch(authenticationSignUpProvider),
      authenticationSignOutUseCase: ref.watch(authenticationSignOutProvider),
      authenticationGetUserUseCase: ref.watch(authenticationGetUserProvider),
    );
  },
);
