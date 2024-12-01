import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification_system/channel/domain/use_cases/get_user_channels_use_case.dart';
import 'package:notification_system/channel/presentation/controllers/providers/channel_repository_provider.dart';

final getUserChannelsProvider = Provider(
  (ref) {
    final repository = ref.watch(channelRepositoryProvider);
    return GetUserChannelsUseCase(repository);
  },
);
