import '../../domain/entities/channel.dart';
import '../../domain/repository/channel_repository.dart';
import '../data_source/channel_remote_data_source.dart';

class ChannelRepository implements BaseChannelRepository {
  final BaseChannelRemoteDataSource _channelRemoteDataSource;

  ChannelRepository(this._channelRemoteDataSource);

  @override
  Future<List<Channel>> getChannels() async {
    return await _channelRemoteDataSource.getChannels();
  }

  @override
  Future<Channel?> addChannel(String userId, String channelName) async {
    return await _channelRemoteDataSource.addChannel(userId, channelName);
  }

  @override
  Future<Channel?> removeChannel(String channelName) async {
    return await _channelRemoteDataSource.removeChannel(channelName);
  }

  @override
  Future<Channel?> subscribeToChannel(String userId, String channelName) async {
    return await _channelRemoteDataSource.subscribeToChannel(
        userId, channelName);
  }

  @override
  Future<bool?> unsubscribeFromChannel(
      String userId, String channelName) async {
    return await _channelRemoteDataSource.unsubscribeFromChannel(
        userId, channelName);
  }

  @override
  Future<List<Channel>> getUserChannels(String userId) async {
    return await _channelRemoteDataSource.getUserChannels(userId);
  }
}
