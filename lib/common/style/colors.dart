import 'package:flutter/material.dart';

/// The scheme of the application.
class Scheme {
  static Color primary(ThemeMode theme) =>
      theme == ThemeMode.light ? Light.primary : Dark.primary;
  static Color primaryText(ThemeMode theme) =>
      theme == ThemeMode.light ? Light.primaryText : Dark.primaryText;
  static Color accent(ThemeMode theme) =>
      theme == ThemeMode.light ? Light.accent : Dark.accent;
}

/// The Light theme colors.
class Light {
  static const Color primary = Color(0xFFFFFFFF);
  static const Color primaryText = Color(0xFF1A1A1A);
  static const Color accent = Color(0xFFFF7349);
}

/// The Dark theme colors.
class Dark {
  static const Color primary = Color(0xFF1A1A1A);
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color accent = Color(0xFFFF7349);
}
