import '../../../authentication/domain/use_cases/authentication_use_case.dart';
import '../repository/channel_repository.dart';

class UnsubscribeToChannelUseCaseParams {
  final String userId;
  final String channelId;

  UnsubscribeToChannelUseCaseParams(this.userId, this.channelId);
}

class UnsubscribeToChannelUseCase
    implements UseCase<UnsubscribeToChannelUseCaseParams, Future<bool?>> {
  final BaseChannelRepository _channelRepository;

  UnsubscribeToChannelUseCase(this._channelRepository);

  @override
  Future<bool?> execute(UnsubscribeToChannelUseCaseParams input) {
    return _channelRepository.unsubscribeFromChannel(
        input.userId, input.channelId);
  }
}
