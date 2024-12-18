import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chato/core/extensions/validation_extensions.dart';

import '../../../../../core/generic_components/generic_text_form_field/generic_text_form_field.dart';
import '../../../controllers/authentication_controller.dart';

class SignUpForm extends ConsumerWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<TextEditingController> registerControllers =
        List.generate(4, (_) => TextEditingController());
    final List<GlobalKey<FormFieldState>> registerKeys =
        List.generate(4, (_) => GlobalKey<FormFieldState>());
    final GlobalKey<FormState> registerFromKey = GlobalKey<FormState>();

    return Form(
      key: registerFromKey,
      child: Column(
        children: [
          GenericTextFormField(
            fieldKey: registerKeys[0],
            labelText: 'Username',
            validator: (value) =>
                value!.isValidUsername ? null : 'Please enter a valid username',
            controller: registerControllers[0],
            onChanged: (value) => registerKeys[0].currentState!.validate(),
          ),
          const SizedBox(height: 16),
          GenericTextFormField(
            fieldKey: registerKeys[1],
            labelText: 'Email',
            validator: (value) => value!.isValidEmail
                ? null
                : 'Please enter a valid email address',
            onChanged: (value) => registerKeys[1].currentState!.validate(),
            controller: registerControllers[1],
          ),
          const SizedBox(height: 16),
          GenericTextFormField(
            fieldKey: registerKeys[2],
            labelText: 'Password',
            obscureText: true,
            validator: (value) => value!.isValidPassword
                ? null
                : 'Password must be at least 8 characters long',
            controller: registerControllers[2],
            onChanged: (value) => registerKeys[2].currentState!.validate(),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () async {
              if (!registerFromKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid Email or Password')),
                );
                return;
              }
              await ref.read(authenticationControllerProvider.notifier).signUp(
                    registerControllers[0].text,
                    registerControllers[1].text,
                    registerControllers[2].text,
                  );
            },
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}
