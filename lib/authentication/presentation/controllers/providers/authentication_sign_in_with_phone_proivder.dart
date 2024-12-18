import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/use_cases/authentication_sign_in_with_phone_use_case.dart';
import 'authentication_repository_provider.dart';

final authenticationSignInWithPhoneProvider = Provider(
      (ref) {
    final repository = ref.watch(authenticationRepositoryProvider);
    return AuthenticationSignInWithPhoneUseCase(repository);
  },
);
