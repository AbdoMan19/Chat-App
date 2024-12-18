import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chato/authentication/presentation/controllers/authentication_controller.dart';
import 'package:chato/core/extensions/validation_extensions.dart';

import '../../../../../core/generic_components/generic_text_form_field/generic_text_form_field.dart';

class SignInForm extends ConsumerWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<TextEditingController> loginControllers =
        List.generate(2, (_) => TextEditingController());
    final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
    final List<GlobalKey<FormFieldState>> loginKeys =
        List.generate(2, (_) => GlobalKey<FormFieldState>());

    return Form(
      key: loginFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GenericTextFormField(
            fieldKey: loginKeys[0],
            labelText: 'Email',
            validator: (value) => value!.isValidEmail
                ? null
                : 'Please enter a valid email address',
            controller: loginControllers[0],
            onChanged: (value) => loginKeys[0].currentState!.validate(),
          ),
          const SizedBox(height: 16),
          GenericTextFormField(
            fieldKey: loginKeys[1],
            labelText: 'Password',
            obscureText: true,
            controller: loginControllers[1],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () async {
              if (!loginFormKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid Email or Password')),
                );
                return;
              }
              await ref.read(authenticationControllerProvider.notifier).signIn(
                    loginControllers[0].text,
                    loginControllers[1].text,
                  );
            },
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}
