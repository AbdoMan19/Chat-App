import '../../domain/entities/user.dart';
import '../../domain/repository/base_authentication_repository.dart';
import '../data_source/authentication_remote_data_source.dart';

class AuthenticationRepository implements BaseAuthenticationRepository {
  final BaseAuthenticationRemoteDataSource remoteDataSource;

  AuthenticationRepository(this.remoteDataSource);

  @override
  Future<User?> signIn(String email, String password)async {
    return await remoteDataSource.signIn(email, password);
  }

  @override
  Future<User?> signUp(String username, String email, String password) async{
    return await remoteDataSource.signUp(username, email, password);
  }

  @override
  Future<void> signOut() async {
    return await remoteDataSource.signOut();
  }

  @override
  Future<User?> getCurrentUser() async{
    return await remoteDataSource.getCurrentUser();
  }

  @override
  Future<User?> signInWithGoogle() async{
    return await remoteDataSource.signInWithGoogle();
  }

  @override
  Future<String?> signInWithPhone(String phone) async {
    return await remoteDataSource.signInWithPhoneNumber(phone);
  }

  @override
  Future<User?> verifyPhoneNumber(String verificationId, String smsCode) async {
    return await remoteDataSource.verifyPhoneNumber(verificationId, smsCode);
  }

}
