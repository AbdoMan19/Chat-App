import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chato/authentication/domain/repository/base_authentication_repository.dart';

import '../../../data/data_source/authentication_remote_data_source.dart';
import '../../../data/repository/authentication_repository.dart';

final authenticationRepositoryProvider = Provider<BaseAuthenticationRepository>(
  (ref) {
    final firebaseAuth = FirebaseAuth.instance;
    final googleSignIn = GoogleSignIn();
    final authDataSource =
        AuthenticationRemoteDataSource(firebaseAuth, googleSignIn);
    return AuthenticationRepository(authDataSource);
  },
);
