import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification_system/authentication/domain/use_cases/authentication_sign_in_use_case.dart';

import 'authentication_repository_provider.dart';

final authenticationSignInProvider = Provider(
  (ref) {
    final repository = ref.watch(authenticationRepositoryProvider);
    return AuthenticationSignInUseCase(repository);
  },
);
