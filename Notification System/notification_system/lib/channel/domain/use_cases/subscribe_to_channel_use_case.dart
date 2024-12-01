import 'package:notification_system/channel/domain/entities/channel.dart';

import '../../../authentication/domain/use_cases/authentication_use_case.dart';
import '../repository/channel_repository.dart';

class SubscribeToChannelUseCaseParams {
  final String userId;
  final String channelId;

  SubscribeToChannelUseCaseParams(this.userId, this.channelId);
}

class SubscribeToChannelUseCase
    implements UseCase<SubscribeToChannelUseCaseParams, Future<Channel?>> {
  final BaseChannelRepository _channelRepository;

  SubscribeToChannelUseCase(this._channelRepository);

  @override
  Future<Channel?> execute(SubscribeToChannelUseCaseParams input) {
    return _channelRepository.subscribeToChannel(input.userId, input.channelId);
  }
}
