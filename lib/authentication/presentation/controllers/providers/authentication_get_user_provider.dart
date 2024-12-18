import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chato/authentication/domain/use_cases/authentication_get_user_use_case.dart';
import 'package:chato/authentication/presentation/controllers/providers/authentication_repository_provider.dart';

final authenticationGetUserProvider = Provider(
  (ref) {
    final repository = ref.watch(authenticationRepositoryProvider);
    return AuthenticationGetUserUseCase(repository);
  },
);
