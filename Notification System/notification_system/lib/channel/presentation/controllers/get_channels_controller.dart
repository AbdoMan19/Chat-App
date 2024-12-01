import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification_system/channel/domain/entities/channel.dart';
import 'package:notification_system/channel/presentation/controllers/providers/get_channels_provider.dart';

final getChannelsController = FutureProvider<List<Channel>>((ref) {
  ref.state = const AsyncValue.loading();
  try {
    final channels = ref.read(getChannelsProvider).execute(null);
    return channels;
  } catch (e) {
    ref.state = AsyncValue.error(e, e as StackTrace);
    rethrow;
  }
});
