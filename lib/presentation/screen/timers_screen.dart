import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/timer/timer_bloc.dart';


class TimersScreen extends StatefulWidget {
  const TimersScreen({super.key, required this.title});
  final String title;

  @override
  State<TimersScreen> createState() => _TimersScreenState();
}

class _TimersScreenState extends State<TimersScreen> {
  int _remainingActiveTime = 30;
  int _duration = 0;
  Axis _timerAxis = Axis.vertical;

  @override
  void initState() {
    super.initState();
    setState(() {
      _duration = context.read<TimerBloc>().state.duration;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.orientationOf(context) == Orientation.portrait) {
      _timerAxis = Axis.vertical;
    }
    if (MediaQuery.orientationOf(context) == Orientation.landscape) {
      _timerAxis = Axis.horizontal;
    }
    return Container(
      constraints: BoxConstraints(
        minHeight: 200.0 ,
        minWidth: 200.0,
        maxWidth: MediaQuery
            .sizeOf(context)
            .width,
        maxHeight: MediaQuery
            .sizeOf(context)
            .height
      ),
      child: Flex(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        direction: _timerAxis,
        children: [
          Expanded(
              flex: 1,
              child: Center(
                child: Card(
                    color: Theme
                        .of(context)
                        .cardColor,
                    shadowColor: Theme.of(context).shadowColor,
                    elevation: 0,
                    child: Text(_remainingActiveTime.toString(),
                        style: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge)),
              )),
          Expanded(
              flex: 1,
              child: Flex(
                direction: _timerAxis,
                children:[ Text(_duration.toString(),
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge),],
              )),
          Expanded(
              flex: 1,
              child: Center(child: reminderTimer(context, _remainingActiveTime.toString())),
      ),],
      ),
    );
  }
}

var reminderTimer = (context, activeTime) =>
(Container(
    height: 20,
    width: 20,
    color: Theme.of(context).cardColor,
    child: Text(activeTime.toString(),
        style: Theme
            .of(context)
            .textTheme
            .bodyLarge)
));
