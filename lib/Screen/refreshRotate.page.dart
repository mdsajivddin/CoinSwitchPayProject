import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RefreshRotatePage extends StatefulWidget {
  const RefreshRotatePage({super.key});

  @override
  State<RefreshRotatePage> createState() => _RefreshRotatePageState();
}

class _RefreshRotatePageState extends State<RefreshRotatePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(); // Yeh icon ko lagatar ghumayega
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: const Icon(Icons.refresh, color: Color(0xFF06CE8F), size: 20),
    );
  }
}
