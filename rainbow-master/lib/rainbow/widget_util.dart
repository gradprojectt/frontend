import 'package:flutter/material.dart';

showSnackBar({
  required BuildContext context,
  required String text,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(
        text,
      ),
      backgroundColor: Colors.black,
      padding: const EdgeInsets.all(16),
    ),
  );
}
