import '../entities/user.dart';
import '../repository/base_authentication_repository.dart';
import 'authentication_use_case.dart';

class AuthenticationSignInWithPhoneUseCase
    extends UseCase<String, Future<String?>> {
  final BaseAuthenticationRepository repository;

  AuthenticationSignInWithPhoneUseCase(this.repository);

  @override
  Future<String?> execute(String input) {
    return repository.signInWithPhone(input);
  }
}
