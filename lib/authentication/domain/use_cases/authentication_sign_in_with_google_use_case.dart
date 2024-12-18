import '../entities/user.dart';
import '../repository/base_authentication_repository.dart';
import 'authentication_use_case.dart';

class AuthenticationSignInWithGoogleUseCase
    extends UseCase<void, Future<User?>> {
  final BaseAuthenticationRepository repository;

  AuthenticationSignInWithGoogleUseCase(this.repository);

  @override
  Future<User?> execute(void input) {
    return repository.signInWithGoogle();
  }
}
