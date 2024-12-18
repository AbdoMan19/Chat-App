import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chato/authentication/presentation/components/Forms/sign_in_form/sign_in_form.dart';
import 'package:chato/core/extensions/validation_extensions.dart';
import 'package:chato/core/generic_components/generic_dialog/generic_dialog.dart';

import '../../../../../core/generic_components/generic_text_form_field/generic_text_form_field.dart';
import '../../../controllers/channels_controller.dart';

class ChannelsNewDialog extends ConsumerStatefulWidget {
  const ChannelsNewDialog({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<ChannelsNewDialog> createState() => _ChannelsNewDialogState();
}

class _ChannelsNewDialogState extends ConsumerState<ChannelsNewDialog> {
  TextEditingController controller = TextEditingController();
  GlobalKey<FormFieldState> fieldKey = GlobalKey<FormFieldState>();
  bool channelFound = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GenericDialog(
      title: 'Add new channel',
      description: 'Enter the name of the new channel',
      content: [
        GenericTextFormField(
          onChanged: (value) => fieldKey.currentState!.validate(),
          labelText: 'Channel name',
          fieldKey: fieldKey,
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty || !value.isValidTopicName) {
              return 'Please enter a channel name';
            }
            return null;
          },
        ),
        if (channelFound)
          const SizedBox(
            height: 20,
            child: Text(
              'This channel exist already',
              style: TextStyle(color: Colors.red),
            ),
          )
      ],
      buttonText: 'Add',
      onButtonPressed: () async {
        if (fieldKey.currentState!.validate()) {
          final result = await ref
              .read(channelControllerProvider.notifier)
              .addChannel(widget.userId, controller.text);
          if (result == true) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
          } else {
            setState(() {
              channelFound = true;
            });
          }
        }
      },
    );
  }
}
