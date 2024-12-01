import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification_system/channel/domain/entities/channel.dart';
import 'package:notification_system/channel/presentation/controllers/channels_controller.dart';

import '../../controllers/messages_controller.dart';
import '../message_bubble/message_bubble.dart';

class ChannelPage extends ConsumerStatefulWidget {
  const ChannelPage({super.key, required this.channel, required this.userId});

  final Channel channel;
  final String userId;

  @override
  ConsumerState<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends ConsumerState<ChannelPage> {
  final ScrollController _scrollController = ScrollController();
  int previousMessageCount = 0;

  @override
  Widget build(BuildContext context) {
    final chatMessages =
        ref.watch(chatRoomControllerProvider(widget.channel.id));
    ref
        .read(chatRoomControllerProvider(widget.channel.id).notifier)
        .loadMessages();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (chatMessages.length > previousMessageCount) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
      previousMessageCount = chatMessages.length;
    });

    return Column(
      children: [
        AppBar(
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Colors.transparent,
          titleSpacing: 12,
          iconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.primary),
          elevation: 0,
          title: Text(
            widget.channel.name,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                ref
                    .read(channelControllerProvider.notifier)
                    .unsubscribeFromChannel(
                      widget.userId,
                      widget.channel.name,
                    );
              },
            ),
          ],
          toolbarHeight: 60,
        ),
        const Divider(),
        Expanded(
          child: chatMessages.isEmpty
              ? const Center(child: Text('No messages yet'))
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: chatMessages.length,
                  itemBuilder: (context, index) {
                    bool isMe = chatMessages[index].senderId == widget.userId;
                    return MessageBubble(
                      isMe: isMe,
                      message: chatMessages[index],
                      userId: widget.userId,
                    );
                  },
                ),
        ),
      ],
    );
  }
}