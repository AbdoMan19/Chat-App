import '../../../authentication/domain/use_cases/authentication_use_case.dart';
import '../entities/channel.dart';
import '../repository/channel_repository.dart';

class RemoveChannelUseCase implements UseCase<String, Future<Channel?>> {
  final BaseChannelRepository _channelRepository;

  RemoveChannelUseCase(this._channelRepository);

  @override
  Future<Channel?> execute(String input) {
    return _channelRepository.removeChannel(input);
  }
}
