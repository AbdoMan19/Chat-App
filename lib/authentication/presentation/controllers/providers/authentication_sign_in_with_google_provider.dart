import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chato/authentication/domain/use_cases/authentication_sign_in_with_google_use_case.dart';

import 'authentication_repository_provider.dart';

final authenticationSignInWithGoogleProvider = Provider(
  (ref) {
    final repository = ref.watch(authenticationRepositoryProvider);
    return AuthenticationSignInWithGoogleUseCase(repository);
  },
);
