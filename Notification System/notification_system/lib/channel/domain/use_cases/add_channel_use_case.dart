import 'package:notification_system/channel/domain/use_cases/channel_use_case.dart';

import '../entities/channel.dart';
import '../repository/channel_repository.dart';

class AddChannelUseCaseParams {
  final String userId;
  final String channelName;

  AddChannelUseCaseParams(this.userId, this.channelName);
}

class AddChannelUseCase
    implements UseCase<AddChannelUseCaseParams, Future<Channel?>> {
  final BaseChannelRepository _channelRepository;

  AddChannelUseCase(this._channelRepository);

  @override
  Future<Channel?> execute(AddChannelUseCaseParams input) {
    return _channelRepository.addChannel(input.userId, input.channelName);
  }
}
