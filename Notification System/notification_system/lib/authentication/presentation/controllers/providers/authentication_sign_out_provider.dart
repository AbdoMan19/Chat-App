import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification_system/authentication/domain/use_cases/authentication_sign_out_use_case.dart';

import 'authentication_repository_provider.dart';

final authenticationSignOutProvider = Provider(
  (ref) {
    final repository = ref.watch(authenticationRepositoryProvider);
    return AuthenticationSignOutUseCase(repository);
  },
);
