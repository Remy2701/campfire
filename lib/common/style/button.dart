import 'package:flutter/material.dart';

final ButtonStyle defaultButtonStyle = ButtonStyle(
  backgroundColor: WidgetStateColor.resolveWith(
    (states) => const Color(0xFF1A1A1A),
  ),
  shape: WidgetStateProperty.resolveWith(
    (states) => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
  ),
);

final ButtonStyle defaultButtonStyleDark = ButtonStyle(
  backgroundColor: WidgetStateColor.resolveWith(
    (states) => const Color(0xFF202020),
  ),
  shape: WidgetStateProperty.resolveWith(
    (states) => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
  ),
);

final ButtonStyle accentButtonStyle = ButtonStyle(
  backgroundColor: WidgetStateColor.resolveWith(
    (states) => states.contains(WidgetState.disabled) ? const Color(0xFFD9D9D9) : const Color(0xFFFF7349),
  ),
  shape: WidgetStateProperty.resolveWith(
    (states) => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
  ),
);

final ButtonStyle accentButtonStyleDark = ButtonStyle(
  backgroundColor: WidgetStateColor.resolveWith(
    (states) => states.contains(WidgetState.disabled) ? const Color(0xFF2A2A2A) : const Color(0xFFFF7349),
  ),
  shape: WidgetStateProperty.resolveWith(
    (states) => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
  ),
);

enum Position {
  start,
  middle,
  end,
  startLeft,
  startRight,
  endLeft,
  endRight,
  single;

  bool isTL() => this == Position.start || this == Position.startLeft || this == Position.single;
  bool isTR() => this == Position.start || this == Position.startRight || this == Position.single;
  bool isBL() => this == Position.end || this == Position.endLeft || this == Position.single;
  bool isBR() => this == Position.end || this == Position.endRight || this == Position.single;
}

InputDecoration defaultTextField({
  required String labelText,
  Position position = Position.middle,
  required ThemeMode theme,
}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: TextStyle(
      color: theme == ThemeMode.dark ? const Color(0xFFEEEEEE) : const Color(0xFF1A1A1A),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
    ),
    fillColor: theme == ThemeMode.dark ? const Color(0xFF000000) : const Color(0xFFEEEEEE),
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(position.isTL() ? 12.0 : 0.0),
        topRight: Radius.circular(position.isTR() ? 12.0 : 0.0),
        bottomLeft: Radius.circular(position.isBL() ? 12.0 : 0.0),
        bottomRight: Radius.circular(position.isBR() ? 12.0 : 0.0),
      ),
      borderSide: BorderSide.none,
    ),
  );
}
