import 'package:flutter/material.dart';
import 'package:notification_system/core/generic_components/generic_icon_button/generic_icon_button.dart';
import 'package:notification_system/core/utils/open_dialogs.dart';

import '../dialogs/channels_join_or_new_dialog/channels_join_or_new_dialog.dart';

class ChannelAddButton extends StatelessWidget {
  const ChannelAddButton({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return GenericIconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        OpenDialogs.openCustomDialog(
          context: context,
          dialog: ChannelsJoinOrNewDialog(userId: userId),
        );
      },
    );
  }
}
