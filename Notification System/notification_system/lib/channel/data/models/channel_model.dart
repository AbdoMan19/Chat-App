import 'package:notification_system/channel/domain/entities/channel.dart';

class ChannelModel extends Channel {
  ChannelModel({
    required super.id,
    required super.name,
    required super.subscribers,
  });

  factory ChannelModel.fromFireStore(String id, Map<String, dynamic> data) {
    return ChannelModel(
      id: id,
      name: data['name'],
      subscribers: List<String>.from(data['subscribers'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': super.id,
      'name': super.name,
      'subscribers': super.subscribers,
    };
  }
}
