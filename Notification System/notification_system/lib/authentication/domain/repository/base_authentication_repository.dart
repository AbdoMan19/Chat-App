import '../entities/user.dart';

abstract class BaseAuthenticationRepository {
  Future<User?> getCurrentUser();

  Future<User?> signIn(String email, String password);

  Future<void> signOut();

  Future<User?> signUp(String username, String email, String password);
}
