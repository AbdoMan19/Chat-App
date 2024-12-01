import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification_system/authentication/presentation/controllers/authentication_controller.dart';
import 'package:notification_system/channel/presentation/controllers/channels_controller.dart';

import '../components/channel_add_button/channel_add_button.dart';
import '../components/channel_icon/channel_icon.dart';
import '../components/channel_page/channel_page.dart';
import '../components/channels_button/channels_button.dart';
import '../controllers/messages_controller.dart';

class ChannelScreen extends ConsumerStatefulWidget {
  const ChannelScreen({super.key});

  String get routeName => '/';

  @override
  ConsumerState<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends ConsumerState<ChannelScreen> {
  int _selectedIndex = 0;
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(channelControllerProvider.notifier).loadChannels(
            ref.watch(authenticationControllerProvider).user!.uuid,
          );
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final channelControllerState = ref.watch(channelControllerProvider);
    final user = ref.watch(authenticationControllerProvider).user!;
    final List<Widget> channelsPages = channelControllerState.channels
        .map((channel) => ChannelPage(channel: channel, userId: user.uuid))
        .toList();
    final channel = channelControllerState.channels.isNotEmpty
        ? channelControllerState.channels[_selectedIndex]
        : null;

    return WillPopScope(
      onWillPop: () {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else {
          exit(0);
        }
        return Future.value(true);
      },
      child: RefreshIndicator(
        onRefresh: () async {
          ref.read(channelControllerProvider.notifier).loadChannels(user.uuid);
        },
        child: Scaffold(
          appBar: AppBar(toolbarHeight: 0),
          body: channelControllerState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  children: [
                    Container(
                      width: 70,
                      color: Theme.of(context).colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: ListView(
                          children: [
                            ChannelsButton(userId: user.uuid),
                            const Divider(indent: 15, endIndent: 15),
                            for (int i = 0;
                                i < channelControllerState.channels.length;
                                i++) ...[
                              InkWell(
                                onTap: () => setState(() => _selectedIndex = i),
                                child: ChannelIcon(
                                    icon: Text(channelControllerState
                                        .channels[i].name[0])),
                              ),
                              const SizedBox(height: 10),
                            ],
                            const Divider(indent: 15, endIndent: 15),
                            ChannelAddButton(
                              userId: user.uuid,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: VerticalDivider(
                        width: 1,
                        thickness: 1,
                      ),
                    ),
                    channelsPages.isEmpty
                        ? const Expanded(
                            child: Center(
                              child: Text(
                                'No channels available',
                              ),
                            ),
                          )
                        : Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background
                                        .withOpacity(0.5),
                                    child: channelsPages[_selectedIndex],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: messageController,
                                    keyboardType: TextInputType.multiline,
                                    focusNode: FocusNode(),
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      hintText: 'Type a message',
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.send),
                                        onPressed: () {
                                          final message =
                                              messageController.text.trim();
                                          if (message.isNotEmpty) {
                                            ref
                                                .read(
                                                    chatRoomControllerProvider(
                                                            channel!.id)
                                                        .notifier)
                                                .sendMessage(
                                                  message,
                                                  user.uuid,
                                                  user.name,
                                                );
                                            messageController.clear();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
        ),
      ),
    );
  }
}
