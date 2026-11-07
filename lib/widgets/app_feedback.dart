import 'package:flutter/material.dart';
import '../utils/auth_error_messages.dart';

void showAppMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

void showAppError(BuildContext context, Object error) =>
    showAppMessage(context, friendlyAuthError(error));
