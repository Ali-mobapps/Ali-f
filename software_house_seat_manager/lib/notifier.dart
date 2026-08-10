import 'package:flutter/material.dart';

class AppNotifier {
  static final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void showFineAlert(int amount) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('Warning: A fine of $amount has been added to your account due to a no-show.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  static void showSuccess(String message) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  static void showError(String message) {
    debugPrint('SHOWING ERROR: $message');
    messengerKey.currentState?.clearSnackBars();
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
