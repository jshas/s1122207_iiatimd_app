import 'package:flutter/material.dart';

class TimersScreen extends StatefulWidget {
  const TimersScreen({super.key, required this.title});
  final String title;

  @override
  State<TimersScreen> createState() => _TimersScreenState();
}

class _TimersScreenState extends State<TimersScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
