import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';

ColorScheme colorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF64FFDA),
  brightness: Brightness.dark,
);

AppBarTheme appBarTheme = const AppBarTheme(
  systemOverlayStyle: SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ),
);

ThemeData darkTheme = ThemeData(
  colorScheme: colorScheme,
  fontFamily: 'Parkinsans',
  appBarTheme: appBarTheme,
);
