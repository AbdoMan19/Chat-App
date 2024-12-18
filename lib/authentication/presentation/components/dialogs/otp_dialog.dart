import 'package:chato/authentication/presentation/components/dialogs/phone_dialog.dart';
import 'package:chato/core/generic_components/generic_dialog/generic_dialog.dart';
import 'package:chato/core/utils/open_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../channel/presentation/screens/channel_screen.dart';
import '../../controllers/authentication_controller.dart';

class OTPDialog extends ConsumerWidget {
  OTPDialog({super.key , required this.verificationId});
  final String verificationId;
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());
  @override
  Widget build(BuildContext context , WidgetRef ref) {
    return GenericDialog(
      title: 'Verification',
      description:
      'Enter the OTP sent to your phone number to verify your account',
      content: [
        _buildCodeInputs(context),
      ],
      buttonText: 'Verify',
      textAlign: TextAlign.center,
      onButtonPressed: () async {
        ref.read(authenticationControllerProvider.notifier).verifyPhoneNumber(verificationId, _controllers.map((e) => e.text).join()).then(
              (value) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pop();
                if(ref.watch(authenticationControllerProvider).user != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Phone number verified successfully')),
                  );
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ChannelScreen(),
                    ),
                  );
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('An error occurred while verifying the phone number')),
                  );
                }
              });
          },
        );
      },
      contentPlacement: ContentPlacement.afterTitle,
    );
  }

  Widget _buildCodeInputs(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 55,
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: TextFormField(
              controller: _controllers[index],
              keyboardType: TextInputType.number,
              maxLength: 1,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                counterText: '',
                contentPadding: const EdgeInsets.all(20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}