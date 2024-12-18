import 'dart:developer';

import 'package:chato/core/utils/open_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/generic_components/generic_dialog/generic_dialog.dart';
import '../../controllers/authentication_controller.dart';
import 'otp_dialog.dart';

class PhoneDialog extends ConsumerWidget {
  PhoneDialog({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    log(ref.watch(authenticationControllerProvider).isLoading.toString());
    return GenericDialog(
      title: 'Phone Number',
      description: 'Enter your phone number to verify your account',
      content: [
        TextFormField(
          controller: _controller,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'Phone Number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
      buttonText: 'Send OTP',
      textAlign: TextAlign.center,
      disabled: ref.watch(authenticationControllerProvider).isLoading,
      onButtonPressed: () async {
        String? verificationId = await ref.read(authenticationControllerProvider.notifier).signInWithPhone(_controller.text);
        log('verificationId: $verificationId');
        if(verificationId == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('An error occurred while sending the OTP')),
            );
          });
        }else{
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pop();
            OpenDialogs.openCustomDialog(
              context: context,
              dialog: OTPDialog(verificationId: verificationId),
            );
          });
        }
      },
      contentPlacement: ContentPlacement.afterTitle,
    );
  }
}
