import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification_system/authentication/domain/repository/base_authentication_repository.dart';

import '../../../data/data_source/authentication_remote_data_source.dart';
import '../../../data/repository/authentication_repository.dart';

final authenticationRepositoryProvider = Provider<BaseAuthenticationRepository>(
  (ref) {
    final firebaseAuth = FirebaseAuth.instance;
    final authDataSource = AuthenticationRemoteDataSource(firebaseAuth);
    return AuthenticationRepository(authDataSource);
  },
);
