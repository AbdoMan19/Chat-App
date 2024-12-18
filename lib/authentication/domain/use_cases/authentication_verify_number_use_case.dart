import '../../../channel/domain/use_cases/channel_use_case.dart';
import '../entities/user.dart';
import '../repository/base_authentication_repository.dart';

class AuthenticationVerifyNumberUseCaseParams{
  final String verificationId;
  final String smsCode;

  AuthenticationVerifyNumberUseCaseParams(this.verificationId, this.smsCode);
}

class AuthenticationVerifyNumberUseCase
    extends UseCase<AuthenticationVerifyNumberUseCaseParams, Future<User?>> {
  final BaseAuthenticationRepository repository;

  AuthenticationVerifyNumberUseCase(this.repository);

  @override
  Future<User?> execute(AuthenticationVerifyNumberUseCaseParams input) {
    return repository.verifyPhoneNumber(input.verificationId, input.smsCode);
  }
}
