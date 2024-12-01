import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification_system/channel/domain/use_cases/unsubscribe_to_channel_use_case.dart';

import 'channel_repository_provider.dart';

final unsubscribeToChannelProvider = Provider(
  (ref) {
    final repository = ref.watch(channelRepositoryProvider);
    return UnsubscribeToChannelUseCase(repository);
  },
);
