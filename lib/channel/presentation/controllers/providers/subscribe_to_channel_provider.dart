import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chato/channel/domain/use_cases/subscribe_to_channel_use_case.dart';

import 'channel_repository_provider.dart';

final subscribeToChannelProvider = Provider(
  (ref) {
    final repository = ref.watch(channelRepositoryProvider);
    return SubscribeToChannelUseCase(repository);
  },
);
