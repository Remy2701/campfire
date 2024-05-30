import 'package:flutter/material.dart';

final ButtonStyle primaryButtonStyle = ButtonStyle(
  backgroundColor: WidgetStateColor.resolveWith(
    (states) => const Color(0xFFEEEEEE),
  ),
  shape: WidgetStateProperty.resolveWith(
    (states) => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
  ),
);

final ButtonStyle primaryButtonStyleDark = ButtonStyle(
  backgroundColor: WidgetStateColor.resolveWith(
    (states) => const Color(0xFF1A1A1A),
  ),
  shape: WidgetStateProperty.resolveWith(
    (states) => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
  ),
);
