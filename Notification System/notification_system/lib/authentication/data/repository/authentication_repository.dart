import '../../domain/entities/user.dart';
import '../../domain/repository/base_authentication_repository.dart';
import '../data_source/authentication_remote_data_source.dart';

class AuthenticationRepository implements BaseAuthenticationRepository {
  final BaseAuthenticationRemoteDataSource remoteDataSource;

  AuthenticationRepository(this.remoteDataSource);

  @override
  Future<User?> signIn(String email, String password) {
    return remoteDataSource.signIn(email, password);
  }

  @override
  Future<User?> signUp(String username, String email, String password) {
    return remoteDataSource.signUp(username, email, password);
  }

  @override
  Future<void> signOut() {
    return remoteDataSource.signOut();
  }

  @override
  Future<User?> getCurrentUser() {
    return remoteDataSource.getCurrentUser();
  }
}
