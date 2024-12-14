import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/use_cases/remove_channel_use_case.dart';
import 'channel_repository_provider.dart';

final removeChannelProvider = Provider(
  (ref) {
    final repository = ref.watch(channelRepositoryProvider);
    return RemoveChannelUseCase(repository);
  },
);
