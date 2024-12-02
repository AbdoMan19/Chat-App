import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/message.dart';

class ChatRoomController extends StateNotifier<List<Message>> {
  final DatabaseReference chatRef;

  ChatRoomController(this.chatRef) : super([]);

  Future<void> sendMessage(
      String messageText, String senderId, String senderName) async {
    try {
      log("Sending message: $messageText to ${chatRef.path}");
      final newMessageRef = chatRef.push();
      await newMessageRef.set({
        'senderName': senderName,
        'senderId': senderId,
        'text': messageText,
        'timestamp': ServerValue.timestamp,
      });
    } catch (e) {
      log("Error sending message: $e");
    }
  }

  Future<void> loadMessages() async {
    final messagesSnapshot = await chatRef.once();
    if (messagesSnapshot.snapshot.value != null) {
      final messages =
          Map<dynamic, dynamic>.from(messagesSnapshot.snapshot.value as Map);

      final loadedMessages = messages.entries.map((entry) {
        final value = Map<String, dynamic>.from(entry.value as Map);
        return Message(
          senderName: value['senderName'] as String,
          senderId: value['senderId'] as String,
          text: value['text'] as String,
          timestamp:
              DateTime.fromMillisecondsSinceEpoch(value['timestamp'] as int),
        );
      }).toList();

      loadedMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      state = loadedMessages;
    }
  }
}

final chatRoomControllerProvider =
    StateNotifierProvider.family<ChatRoomController, List<Message>, String>(
        (ref, channelId) {
  log('Creating chatRoomControllerProvider for channel: $channelId');

  final chatRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://cloud-55e06-default-rtdb.firebaseio.com/',
  ).ref().child('channels').child(channelId).child('messages');

  return ChatRoomController(chatRef);
});
