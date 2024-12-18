import 'package:chato/channel/domain/entities/channel.dart';
import 'package:chato/channel/domain/use_cases/channel_use_case.dart';

import '../repository/channel_repository.dart';

class GetChannelsUseCase implements UseCase<void, Future<List<Channel>>> {
  final BaseChannelRepository _channelRepository;

  GetChannelsUseCase(this._channelRepository);

  @override
  Future<List<Channel>> execute(void input) {
    return _channelRepository.getChannels();
  }
}
