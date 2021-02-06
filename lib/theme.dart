import 'package:flutter/material.dart';

/// Define all colors and text theme here!

Color errorColor = Color(0xFFF5222D);
Color successColor = Color(0xFF52C41A);
Color progressColor = Color(0xFFFFA940);

Color appBarColor = Color(0xFF235264);

Color primaryColor = Color(0xFF235264);
Color accentColor = Color(0xFF189AA7);

Color backgroundWhite = Colors.white;
Color backgroundGreyShade = Color(0xFFE5E5E5);
Color blackColor = Color(0xFF242424);

ThemeData themeData = ThemeData(
  brightness: Brightness.light,
  canvasColor: backgroundWhite,
  primaryColor: primaryColor,
  accentColor: accentColor,
  errorColor: errorColor,
  cardColor: backgroundWhite,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
