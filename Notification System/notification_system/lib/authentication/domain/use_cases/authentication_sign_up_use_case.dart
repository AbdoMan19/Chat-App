import 'package:notification_system/authentication/domain/repository/base_authentication_repository.dart';

import '../entities/user.dart';
import 'authentication_use_case.dart';

class AuthenticationSignUpUseCaseParams {
  final String username;
  final String email;
  final String password;

  AuthenticationSignUpUseCaseParams(this.username, this.email, this.password);
}

class AuthenticationSignUpUseCase
    extends UseCase<AuthenticationSignUpUseCaseParams, Future<User?>> {
  final BaseAuthenticationRepository repository;

  AuthenticationSignUpUseCase(this.repository);

  @override
  Future<User?> execute(AuthenticationSignUpUseCaseParams input) {
    return repository.signUp(input.username, input.email, input.password);
  }
}
