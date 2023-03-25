import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  colorScheme: ThemeData.light().colorScheme.copyWith(
        primary: Colors.white,
        onPrimary: Colors.black,
        secondary: Colors.deepOrange,
        onSecondary: Colors.white,
      ),
);

final darkTheme = ThemeData.dark().copyWith(
  colorScheme: ThemeData.dark().colorScheme.copyWith(
        primary: const Color.fromRGBO(44, 51, 51, 1),
        onPrimary: const Color.fromRGBO(46, 79, 79, 1),
        secondary: const Color.fromRGBO(14, 131, 136, 1),
        onSecondary: const Color.fromRGBO(203, 228, 222, 1),
      ),
);
