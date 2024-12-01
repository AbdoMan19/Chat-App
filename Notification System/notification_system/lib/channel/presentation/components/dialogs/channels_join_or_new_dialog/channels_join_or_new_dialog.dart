import 'package:flutter/material.dart';
import 'package:notification_system/core/utils/open_dialogs.dart';

import '../../../../../core/generic_components/generic_dialog/generic_dialog.dart';
import '../channels_join_dialog/channels_join_dialog.dart';
import '../channels_new_dialog/channels_new_dialog.dart';

class ChannelsJoinOrNewDialog extends StatelessWidget {
  const ChannelsJoinOrNewDialog({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return GenericDialog(
      title: 'Join or Create Channel',
      showButton: false,
      description:
          'Would you like to join an existing channel or create a new one?',
      content: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.5,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  OpenDialogs.openCustomDialog(
                    context: context,
                    dialog: ChannelsJoinDialog(userId: userId),
                  );
                },
                child: const Text("Join"),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.5,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  OpenDialogs.openCustomDialog(
                    context: context,
                    dialog: ChannelsNewDialog(userId: userId),
                  );
                },
                child: const Text("Create New"),
              ),
            ),
          ],
        )
      ],
      buttonText: '',
      onButtonPressed: () {},
    );
  }
}
