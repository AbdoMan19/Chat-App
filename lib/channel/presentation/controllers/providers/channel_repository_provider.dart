import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chato/channel/data/data_source/channel_remote_data_source.dart';

import '../../../data/repository/channel_repository.dart';
import '../../../domain/repository/channel_repository.dart';

final channelRepositoryProvider = Provider<BaseChannelRepository>(
  (ref) {
    final fireStore = FirebaseFirestore.instance;
    final firebaseMessaging = FirebaseMessaging.instance;
    final ChannelRemoteDataSource channelRemoteDataSource =
        ChannelRemoteDataSource(fireStore, firebaseMessaging);
    return ChannelRepository(channelRemoteDataSource);
  },
);
