import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:chato/channel/data/models/channel_model.dart';

abstract class BaseChannelRemoteDataSource {
  Future<List<ChannelModel>> getChannels();

  Future<ChannelModel?> addChannel(String userId, String channelName);

  Future<ChannelModel?> removeChannel(String channelName);

  Future<List<ChannelModel>> getUserChannels(String userId);

  Future<ChannelModel?> subscribeToChannel(String userId, String channelName);

  Future<bool?> unsubscribeFromChannel(String userId, String channelName);
}

class ChannelRemoteDataSource implements BaseChannelRemoteDataSource {
  final FirebaseFirestore _fireStore;
  final FirebaseMessaging _firebaseMessaging;
  final FirebaseAnalytics analytics;

  ChannelRemoteDataSource(this._fireStore, this._firebaseMessaging, this.analytics);

  @override
  Future<ChannelModel?> addChannel(String userId, String channelName) async {
    try {
      final snapshot = await _fireStore
          .collection('channels')
          .where('name', isEqualTo: channelName)
          .get();
      if (snapshot.docs.isNotEmpty) return null;
      final doc = await _fireStore.collection('channels').add({
        'name': channelName,
        'subscribers': [userId],
      });

      await _firebaseMessaging.subscribeToTopic(channelName);
      await logSubscriptionEvent(doc.id);
      return ChannelModel.fromFireStore(doc.id, {
        'name': channelName,
        'subscribers': [userId],
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ChannelModel?> removeChannel(String channelName) async {
    try {
      final snapshot = await _fireStore
          .collection('channels')
          .where('name', isEqualTo: channelName)
          .get();
      if (snapshot.docs.isEmpty) return null;
      await _fireStore.collection('channels').doc(snapshot.docs[0].id).delete();
      await _firebaseMessaging.unsubscribeFromTopic(channelName);
      return ChannelModel.fromFireStore(
          snapshot.docs[0].id, snapshot.docs[0].data());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ChannelModel>> getChannels() {
    try {
      return _fireStore.collection('channels').get().then((snapshot) {
        return snapshot.docs
            .map((doc) => ChannelModel.fromFireStore(doc.id, doc.data()))
            .toList();
      });
    } catch (e) {
      rethrow;
    }
  }

  void logCustomEvent(String eventName, Map<String, Object> parameters) async {
    await analytics.logEvent(
      name: eventName,
      parameters: parameters,
    );
  }

  Future<void> logSubscriptionEvent(String channelId) async {
    log('User subscribed event to channel $channelId');
    await analytics.logEvent(
      name: 'user_subscribed',
      parameters: {'channel_id': channelId },
    ).then((value) => log('User subscribed to channel $channelId'));
  }

  Future<void> logUnsubscriptionEvent(String channelId) async {
    await analytics.logEvent(
      name: 'user_unsubscribed',
      parameters: {'channel_id': channelId},
    ).then((value) => log('User unsubscribed from channel $channelId'));
  }

  @override
  Future<ChannelModel?> subscribeToChannel(
      String userId, String channelName) async {
    try {
      final snapshot = await _fireStore
          .collection('channels')
          .where('name', isEqualTo: channelName)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final channelDoc = snapshot.docs[0];
      final channelId = channelDoc.id;

      await _fireStore.collection('channels').doc(channelId).update({
        'subscribers': FieldValue.arrayUnion([userId]),
      });
      await _firebaseMessaging.subscribeToTopic(channelName);
      await logSubscriptionEvent(channelId);
      return ChannelModel.fromFireStore(channelId, channelDoc.data());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool?> unsubscribeFromChannel(
      String userId, String channelName) async {
    try {
      final snapshot = await _fireStore
          .collection('channels')
          .where('name', isEqualTo: channelName)
          .get();
      if (snapshot.docs.isEmpty) return false;
      if (snapshot.docs[0].data()['subscribers'].length == 1) {
        removeChannel(channelName);
        return true;
      }
      await _fireStore.collection('channels').doc(snapshot.docs[0].id).update({
        'subscribers': FieldValue.arrayRemove([userId]),
      });
      await _firebaseMessaging.unsubscribeFromTopic(channelName);
      await logSubscriptionEvent(snapshot.docs[0].id);
      return true;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<ChannelModel>> getUserChannels(String userId) async {
    try {
      return await _fireStore.collection('channels').get().then((snapshot) {
        return snapshot.docs
            .map((doc) => ChannelModel.fromFireStore(doc.id, doc.data()))
            .where((element) => element.subscribers.contains(userId))
            .toList();
      });
    } catch (e) {
      rethrow;
    }
  }
}
