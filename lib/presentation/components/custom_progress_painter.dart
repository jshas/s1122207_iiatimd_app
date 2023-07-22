import 'package:flutter/material.dart';

class CustomProgressPainter extends StatefulWidget {
  const CustomProgressPainter({super.key});

  @override
  State<CustomProgressPainter> createState() => _CustomProgressPainterState();
}

class _CustomProgressPainterState extends State<CustomProgressPainter> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
