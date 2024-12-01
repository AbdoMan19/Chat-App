import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification_system/channel/presentation/controllers/channels_controller.dart';
import 'package:notification_system/core/generic_components/generic_dialog/generic_dialog.dart';
import 'package:notification_system/core/generic_components/generic_text_form_field/generic_text_form_field.dart';

class ChannelsJoinDialog extends ConsumerStatefulWidget {
  const ChannelsJoinDialog({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<ChannelsJoinDialog> createState() => _ChannelsJoinDialogState();
}

class _ChannelsJoinDialogState extends ConsumerState<ChannelsJoinDialog> {
  bool channelNotFound = false;
  TextEditingController controller = TextEditingController();
  GlobalKey<FormFieldState> fieldKey = GlobalKey<FormFieldState>();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GenericDialog(
      title: 'Join channel',
      description: 'Enter the name of the channel you want to join',
      content: [
        GenericTextFormField(
          onChanged: (value) => fieldKey.currentState!.validate(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a channel name';
            }
            return null;
          },
          labelText: 'Channel name',
          fieldKey: fieldKey,
          controller: controller,
        ),
        if (channelNotFound)
          const SizedBox(
            height: 20,
            child: Text(
              'This channel does not exist',
              style: TextStyle(color: Colors.red),
            ),
          )
      ],
      buttonText: 'Join',
      onButtonPressed: () async {
        if (fieldKey.currentState!.validate()) {
          final result = await ref
              .read(channelControllerProvider.notifier)
              .subscribeToChannel(widget.userId, controller.text);
          if (result == true) {
            Navigator.of(context).pop();
          } else {
            setState(() {
              channelNotFound = true;
            });
          }
        }
      },
    );
  }
}
