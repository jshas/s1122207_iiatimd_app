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
    return Container(
      constraints: BoxConstraints(
        minHeight: 40.0,
        minWidth: 20.0,
        maxWidth: MediaQuery.sizeOf(context).width - MediaQuery.of(context).viewPadding.horizontal,
        maxHeight: MediaQuery.sizeOf(context).height - MediaQuery.of(context).viewPadding.vertical,
      ),
      child: const Flexible(

        fit: FlexFit.tight,
        child: Flex(

              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              direction: Axis.horizontal,
              mainAxisSize: MainAxisSize.min,
              children: [
                Placeholder(fallbackHeight: 100, fallbackWidth: 200,),
                Placeholder(fallbackHeight: 100, fallbackWidth: 200,),
                Placeholder(fallbackHeight: 100, fallbackWidth: 200,),
              ],
            ),
        ),
      );
  }
}
