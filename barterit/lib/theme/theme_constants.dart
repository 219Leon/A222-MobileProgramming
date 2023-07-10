import 'package:flutter/material.dart';

const COLOR_PRIMARY = Colors.orange;
var COLOR_ACCENT = Colors.orange[400];

ThemeData lightTheme = ThemeData(
    primarySwatch: COLOR_PRIMARY,
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: COLOR_ACCENT),
    brightness: Brightness.light);

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    switchTheme: SwitchThemeData(
        trackColor: MaterialStateProperty.all<Color>(Colors.grey),
        thumbColor: MaterialStateProperty.all<Color>(Colors.white)),
    colorScheme: const ColorScheme.dark().copyWith(primary: Colors.orange));
