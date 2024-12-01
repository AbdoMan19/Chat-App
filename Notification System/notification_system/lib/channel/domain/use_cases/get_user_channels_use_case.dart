import '../../../authentication/domain/use_cases/authentication_use_case.dart';
import '../entities/channel.dart';
import '../repository/channel_repository.dart';

class GetUserChannelsUseCase implements UseCase<String, Future<List<Channel>>> {
  final BaseChannelRepository _channelRepository;

  GetUserChannelsUseCase(this._channelRepository);

  @override
  Future<List<Channel>> execute(String input) {
    return _channelRepository.getUserChannels(input);
  }
}
