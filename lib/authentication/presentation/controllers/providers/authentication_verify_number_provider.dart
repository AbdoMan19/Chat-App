import 'package:chato/authentication/domain/use_cases/authentication_verify_number_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'authentication_repository_provider.dart';

final authenticationVerifyNumberProvider = Provider(
      (ref) {
    final repository = ref.watch(authenticationRepositoryProvider);
    return AuthenticationVerifyNumberUseCase(repository);
  },
);
