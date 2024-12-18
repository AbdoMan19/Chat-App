import 'package:flutter/material.dart';

class GenericTextFormField extends StatelessWidget {
  const GenericTextFormField({
    super.key,
    required this.labelText,
    required this.fieldKey,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.onChanged,
  });

  final String labelText;
  final GlobalKey<FormFieldState> fieldKey;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: fieldKey,
      validator: validator,
      obscureText: obscureText,
      onChanged: onChanged,
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
      ),
    );
  }
}
