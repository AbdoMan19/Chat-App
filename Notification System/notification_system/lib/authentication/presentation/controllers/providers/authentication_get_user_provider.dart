import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification_system/authentication/domain/use_cases/authentication_get_user_use_case.dart';
import 'package:notification_system/authentication/presentation/controllers/providers/authentication_repository_provider.dart';

final authenticationGetUserProvider = Provider(
  (ref) {
    final repository = ref.watch(authenticationRepositoryProvider);
    return AuthenticationGetUserUseCase(repository);
  },
);
