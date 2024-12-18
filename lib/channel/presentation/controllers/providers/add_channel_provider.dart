import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chato/channel/domain/use_cases/add_channel_use_case.dart';

import 'channel_repository_provider.dart';

final addChannelProvider = Provider(
  (ref) {
    final repository = ref.watch(channelRepositoryProvider);
    return AddChannelUseCase(repository);
  },
);
