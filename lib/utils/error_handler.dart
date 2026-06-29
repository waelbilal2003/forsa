import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ErrorHandler {
  static void showError(BuildContext context, dynamic error) {
    String message = 'حدث خطأ غير متوقع';
    if (error is ApiException) message = error.message;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}