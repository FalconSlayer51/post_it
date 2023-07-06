import 'package:flutter/material.dart';

void showSnackbar({
  required BuildContext context,
  required MaterialColor color,
  required String text,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor: color,
    ),
  );
}
