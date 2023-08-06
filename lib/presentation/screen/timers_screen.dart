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
  final int _remainingActiveTime = 30;
  int _duration = 0;
  Axis _timerAxis = Axis.vertical;

  @override
  void initState() {
    super.initState();
    setState(() {
      _duration = context
          .read<TimerBloc>()
          .state
          .duration;
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
          minHeight: 200.0,
          minWidth: 200.0,
          maxWidth: MediaQuery
              .sizeOf(context)
              .width,
          maxHeight: MediaQuery
              .sizeOf(context)
              .height),
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
                      shadowColor: Theme
                          .of(context)
                          .shadowColor,
                      elevation: 0,
                      child: Center(
                        child: Text(_remainingActiveTime.toString(),
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge),
                      )),
                )),
            Expanded(
                flex: 1,
                child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text('Duration',
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium),
                    BlocProvider.value(
                      value: BlocProvider.of<TimerBloc>(context),
                      child: TimerText(),
                    ),
                    BlocProvider.value(
                      value: BlocProvider.of<TimerBloc>(context),
                      child: Actions(),
                    ),
                  ],
                )),
            const Expanded(
              flex: 1,
              child: Center(child: Text("Space for active minutes.")),
            ),
          ]),
    );
  }
}

class Actions extends StatelessWidget {
  const Actions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...switch (state) {
              TimerInitial() =>
              [
                FloatingActionButton(
                  child: const Icon(Icons.play_arrow),
                  onPressed: () =>
                      context
                          .read<TimerBloc>()
                          .add(TimerStarted(duration: state.duration)),
                ),
              ],
              TimerRunInProgress() =>
              [
                FloatingActionButton(
                  child: const Icon(Icons.pause),
                  onPressed: () =>
                      context.read<TimerBloc>().add(const TimerPaused()),
                ),
                FloatingActionButton(
                  child: const Icon(Icons.replay),
                  onPressed: () =>
                      context.read<TimerBloc>().add(const TimerReset()),
                ),
              ],
              TimerRunPause() =>
              [
                FloatingActionButton(
                  child: const Icon(Icons.play_arrow),
                  onPressed: () =>
                      context.read<TimerBloc>().add(const TimerResumed()),
                ),
                FloatingActionButton(
                  child: const Icon(Icons.replay),
                  onPressed: () =>
                      context.read<TimerBloc>().add(const TimerReset()),
                ),
              ],
              TimerDurationSet() =>
              [
                FloatingActionButton(
                  child: const Icon(Icons.play_arrow),
                  onPressed: () =>
                      context
                          .read<TimerBloc>()
                          .add(TimerStarted(duration: state.duration)),
                ),
              ],
              TimerRunComplete() =>
              [
                FloatingActionButton(
                  child: const Icon(Icons.replay),
                  onPressed: () =>
                      context.read<TimerBloc>().add(const TimerReset()),
                ),
              ],
            }
          ],
        );
      },
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({super.key});

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minutesStr =
    ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).toString().padLeft(2, '0');
    return Text(
      '$minutesStr:$secondsStr',
      style: Theme
          .of(context)
          .textTheme
          .titleLarge,
    );
  }
}
