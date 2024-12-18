import 'package:chato/core/generic_components/generic_icon_button/generic_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/authentication_controller.dart';

class AuthenticationLogOutButton extends ConsumerWidget {
  const AuthenticationLogOutButton({super.key});

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    return  IconButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        minimumSize: const Size(60, 60),
      ),
      color: Theme.of(context).colorScheme.primary,
      icon: const Icon(Icons.logout),
      onPressed: () {
        ref.read(authenticationControllerProvider.notifier).signOut();
      },
    );
  }
}
