import '../entities/channel.dart';

abstract class BaseChannelRepository {
  Future<List<Channel>> getChannels();

  Future<Channel?> addChannel(String userId, String channelName);

  Future<Channel?> removeChannel(String userId);

  Future<Channel?> subscribeToChannel(String userId, String channelName);

  Future<bool?> unsubscribeFromChannel(String userId, String channelName);

  Future<List<Channel>> getUserChannels(String userId);
}
