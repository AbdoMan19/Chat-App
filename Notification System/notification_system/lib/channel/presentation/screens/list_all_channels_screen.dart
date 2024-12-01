import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/channels_controller.dart';
import '../controllers/get_channels_controller.dart';

class ListAllChannelsScreen extends ConsumerStatefulWidget {
  const ListAllChannelsScreen({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<ListAllChannelsScreen> createState() =>
      _ListAllChannelsScreenState();
}

class _ListAllChannelsScreenState extends ConsumerState<ListAllChannelsScreen> {
  @override
  Widget build(BuildContext context) {
    final channelsState = ref.watch(getChannelsController);
    ref.listen(channelControllerProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!.toString())),
        );
      }
    });
    return RefreshIndicator(
      onRefresh: () async {
        ref.refresh(getChannelsController);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('All Channels'),
        ),
        body: channelsState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('An error occurred: $error'),
                ElevatedButton(
                  onPressed: () {
                    ref.refresh(getChannelsController);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (channels) {
            return ListView.builder(
              itemCount: channels.length,
              itemBuilder: (context, index) {
                final channel = channels[index];
                bool isUserSubscribed =
                    channel.subscribers.contains(widget.userId);
                return ListTile(
                  contentPadding: const EdgeInsets.only(left: 16, right: 8),
                  title: Text(
                    channel.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  trailing: TextButton(
                    child: Text(isUserSubscribed ? 'Unsubscribe' : 'Subscribe'),
                    onPressed: () async {
                      if (isUserSubscribed) {
                        await ref
                            .read(channelControllerProvider.notifier)
                            .unsubscribeFromChannel(
                              widget.userId,
                              channel.name,
                            );
                      } else {
                        await ref
                            .read(channelControllerProvider.notifier)
                            .subscribeToChannel(
                              widget.userId,
                              channel.name,
                            );
                      }
                      setState(() {
                        ref.refresh(getChannelsController);
                      });
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
