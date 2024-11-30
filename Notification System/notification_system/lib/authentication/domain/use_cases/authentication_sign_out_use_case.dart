import '../repository/base_authentication_repository.dart';
import 'authentication_use_case.dart';

class AuthenticationSignOutUseCase extends UseCase<void, Future<void>> {
  final BaseAuthenticationRepository repository;

  AuthenticationSignOutUseCase(this.repository);

  @override
  Future<void> execute(void input) {
    return repository.signOut();
  }
}
