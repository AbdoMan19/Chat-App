import 'package:chato/authentication/presentation/components/dialogs/otp_dialog.dart';
import 'package:chato/core/utils/open_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chato/authentication/presentation/controllers/authentication_controller.dart';

import '../dialogs/phone_dialog.dart';

class SocialAccountsLogin extends ConsumerWidget {
  const SocialAccountsLogin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authenticationControllerProvider.notifier);
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          IconButton(
            onPressed: () {
              authNotifier.signInWithGoogle();
            },
            icon: const Icon(Icons.g_mobiledata_sharp, size: 24),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              OpenDialogs.openCustomDialog(
                  context: context, dialog:  PhoneDialog());
            },
            icon: const Icon(Icons.phone, size: 24),
          ),
        ],
      ),
    );
  }
}
