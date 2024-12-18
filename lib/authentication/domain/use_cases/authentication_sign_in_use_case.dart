import '../entities/user.dart';
import '../repository/base_authentication_repository.dart';
import 'authentication_use_case.dart';

class AuthenticationSignInUseCaseParams {
  final String email;
  final String password;

  AuthenticationSignInUseCaseParams(this.email, this.password);
}

class AuthenticationSignInUseCase
    extends UseCase<AuthenticationSignInUseCaseParams, Future<User?>> {
  final BaseAuthenticationRepository repository;

  AuthenticationSignInUseCase(this.repository);

  @override
  Future<User?> execute(AuthenticationSignInUseCaseParams input) {
    return repository.signIn(input.email, input.password);
  }
}
