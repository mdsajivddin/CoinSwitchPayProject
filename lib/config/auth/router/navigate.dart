import 'package:flutter/material.dart';
import 'package:payment_app/Screen/home.page.dart';

void navigateToMainScreen(BuildContext context, int index) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => HomeBottomNav(initialIndex: index),
    ),
    (route) => false,
  );
}