import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification_system/channel/data/data_source/channel_remote_data_source.dart';

import '../../../data/repository/channel_repository.dart';
import '../../../domain/repository/channel_repository.dart';

final channelRepositoryProvider = Provider<BaseChannelRepository>(
  (ref) {
    final fireStore = FirebaseFirestore.instance;
    final ChannelRemoteDataSource channelRemoteDataSource =
        ChannelRemoteDataSource(fireStore);
    return ChannelRepository(channelRemoteDataSource);
  },
);
