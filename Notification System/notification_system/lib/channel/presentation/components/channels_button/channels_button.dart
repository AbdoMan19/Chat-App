import 'package:flutter/material.dart';
import 'package:notification_system/channel/presentation/screens/list_all_channels_screen.dart';

import '../../../../core/generic_components/generic_icon_button/generic_icon_button.dart';

class ChannelsButton extends StatelessWidget {
  const ChannelsButton({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return GenericIconButton(
      icon: const Icon(Icons.chat),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ListAllChannelsScreen(userId: userId),
          ),
        );
      },
    );
  }
}
