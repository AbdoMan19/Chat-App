import 'package:flutter/material.dart';

class ChannelIcon extends StatelessWidget {
  const ChannelIcon({super.key, required this.icon});

  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      child: icon,
    );
  }
}
