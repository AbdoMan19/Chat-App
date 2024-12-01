import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification_system/channel/domain/use_cases/get_channels_use_case.dart';

import 'channel_repository_provider.dart';

final getChannelsProvider = Provider<GetChannelsUseCase>((ref) {
  final repository = ref.watch(channelRepositoryProvider);
  return GetChannelsUseCase(repository);
});
