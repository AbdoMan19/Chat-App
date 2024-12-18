import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/use_cases/authentication_sign_up_use_case.dart';
import 'authentication_repository_provider.dart';

final authenticationSignUpProvider = Provider(
  (ref) {
    final repository = ref.watch(authenticationRepositoryProvider);
    return AuthenticationSignUpUseCase(repository);
  },
);
