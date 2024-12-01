import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification_system/channel/domain/use_cases/add_channel_use_case.dart';
import 'package:notification_system/channel/domain/use_cases/get_user_channels_use_case.dart';
import 'package:notification_system/channel/domain/use_cases/subscribe_to_channel_use_case.dart';
import 'package:notification_system/channel/presentation/controllers/providers/add_channel_provider.dart';
import 'package:notification_system/channel/presentation/controllers/providers/get_user_channels_provider.dart';
import 'package:notification_system/channel/presentation/controllers/providers/subscribe_to_channel_provider.dart';
import 'package:notification_system/channel/presentation/controllers/providers/unsubscribe_to_channel_provider.dart';

import '../../domain/entities/channel.dart';
import '../../domain/use_cases/unsubscribe_to_channel_use_case.dart';

class ChannelState {
  final List<Channel> channels;
  final bool isLoading;
  final Exception? error;

  ChannelState({
    required this.channels,
    required this.isLoading,
    this.error,
  });
}

class ChannelController extends StateNotifier<ChannelState> {
  final AddChannelUseCase addChannelUseCase;
  final GetUserChannelsUseCase getUserChannelsUseCase;
  final UnsubscribeToChannelUseCase unsubscribeToChannelUseCase;
  final SubscribeToChannelUseCase subscribeToChannelUseCase;

  ChannelController(this.addChannelUseCase, this.getUserChannelsUseCase,
      this.unsubscribeToChannelUseCase, this.subscribeToChannelUseCase)
      : super(ChannelState(channels: [], isLoading: false));

  Future<void> loadChannels(String userId) async {
    try {
      state = ChannelState(channels: [], isLoading: true);
      List<Channel> channels = await getUserChannelsUseCase.execute(userId);
      state = ChannelState(channels: channels, isLoading: false);
    } catch (e) {
      state =
          ChannelState(channels: [], isLoading: false, error: e as Exception);
    }
  }

  Future<bool?> addChannel(String userId, String channelName) async {
    try {
      Channel? result = await addChannelUseCase
          .execute(AddChannelUseCaseParams(userId, channelName));
      if (result != null) {
        state = ChannelState(
            channels: [...state.channels, result], isLoading: false);
        return true;
      }
      return false;
    } catch (e) {
      state = ChannelState(
          channels: state.channels, isLoading: false, error: e as Exception);
    }
    return null;
  }

  Future<bool> subscribeToChannel(String userId, String channelName) async {
    try {
      Channel? result = await subscribeToChannelUseCase
          .execute(SubscribeToChannelUseCaseParams(userId, channelName));
      log(result.toString());
      if (result != null) {
        state = ChannelState(
            channels: [...state.channels, result], isLoading: false);
        return true;
      }
      return false;
    } catch (e) {
      state = ChannelState(
          channels: state.channels, isLoading: false, error: Exception(e));
      rethrow;
    }
    return false;
  }

  Future<bool?> unsubscribeFromChannel(
      String userId, String channelName) async {
    try {
      bool? result = await unsubscribeToChannelUseCase
          .execute(UnsubscribeToChannelUseCaseParams(userId, channelName));
      if (result != null && result) {
        state = ChannelState(
            channels: state.channels
                .where((element) => element.name != channelName)
                .toList(),
            isLoading: false);
      }
      return result;
    } catch (e) {
      state = ChannelState(
          channels: state.channels, isLoading: false, error: e as Exception);
    }
    return null;
  }
}

final channelControllerProvider =
    StateNotifierProvider<ChannelController, ChannelState>(
  (ref) {
    return ChannelController(
      ref.read(addChannelProvider),
      ref.read(getUserChannelsProvider),
      ref.read(unsubscribeToChannelProvider),
      ref.read(subscribeToChannelProvider),
    );
  },
);
