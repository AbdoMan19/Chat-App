import 'package:flutter/material.dart';

class GenericIconButton extends StatelessWidget {
  const GenericIconButton({super.key, required this.icon, this.onPressed});

  final Widget icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        minimumSize: const Size(double.infinity, 60),
      ),
      color: Theme.of(context).colorScheme.primary,
      icon: icon,
      onPressed: onPressed,
    );
  }
}
