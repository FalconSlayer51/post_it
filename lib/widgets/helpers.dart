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

ElevatedButton customButton({
  required BuildContext context,
  required Widget child,
  required Color color,
  required VoidCallback onPressed,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      minimumSize: const Size(double.infinity, 50),
    ),
    child: child,
  );
}

Widget customLoaoder(BuildContext context) {
  return const Center(
    child: CircularProgressIndicator(),
  );
}
