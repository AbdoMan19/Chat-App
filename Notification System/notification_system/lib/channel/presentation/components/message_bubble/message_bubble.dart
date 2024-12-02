import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notification_system/channel/domain/entities/message.dart';

import '../../../../core/utils/time_converter.dart';

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final Message message;
  final String userId;

  const MessageBubble({
    super.key,
    required this.isMe,
    required this.message,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Card(
                  color: isMe
                      ? Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.9)
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12.0),
                      topRight: const Radius.circular(12.0),
                      bottomLeft:
                          isMe ? const Radius.circular(12.0) : Radius.zero,
                      bottomRight:
                          isMe ? Radius.zero : const Radius.circular(12.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message.senderName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: !isMe
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          message.text,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                ),
                Text(
                  textAlign: TextAlign.end,
                  TimeConverter.convertTimeToString(
                    Timestamp.fromDate(message.timestamp),
                  ),
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
