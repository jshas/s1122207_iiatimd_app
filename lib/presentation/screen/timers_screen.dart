import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smallstep/business_logic/active_time/active_time_cubit.dart';
import '../../business_logic/timer/timer_bloc.dart';

class TimersScreen extends StatefulWidget {
  const TimersScreen({super.key, required this.title});

  final String title;

  @override
  State<TimersScreen> createState() => _TimersScreenState();
}

class _TimersScreenState extends State<TimersScreen> {
  Axis _timerAxis = Axis.vertical;

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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          direction: _timerAxis,
          children: [
            Expanded(
                flex: 1,
                child: BlocProvider.value(
                  value: BlocProvider.of<ActiveTimeCubit>(context),
                  child: const ActiveMinutes(),
                )),
            const Divider(
              indent: 20,
              endIndent: 20,
            ),
            const Expanded(flex: 1, child: ReminderDuration()),
            const Divider(
              indent: 20,
              endIndent: 20,
            ),
            const Expanded(flex: 1, child: ActiveMinutesForm()),
          ]),
    );
  }
}

/// The [ActiveMinutesForm] widget is used to display the form unlocked on the TimerRunComplete state
class ActiveMinutesForm extends StatefulWidget {
  const ActiveMinutesForm({super.key});

  @override
  State<ActiveMinutesForm> createState() => _ActiveMinutesFormState();
}

class _ActiveMinutesFormState extends State<ActiveMinutesForm> {
  static int _activeMinutes = 0;
  bool _enabled = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      listener: (context, state) {
        if (context
            .read<TimerBloc>()
            .state == const TimerRunComplete()) {
          _enabled = true;
        }
      },
      bloc:BlocProvider.of<ActiveTimeCubit>(context),
      builder: (context, state) {
        return Expanded(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('Add Active Minutes',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleMedium),
                Text('Complete a timer to fill-in.',
                    style: Theme
                        .of(context)
                        .textTheme
                        .labelMedium),
                TextFormField(
                  enabled: _enabled,
                  decoration: InputDecoration(
                    labelText: 'Active Minutes',
                    hintText:
                    'Enter the number of active minutes you have earned.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    _activeMinutes = int.parse(value);
                  },
                  onFieldSubmitted: (value) {
                    if (_activeMinutes > 0) {
                      context
                          .read<ActiveTimeCubit>()
                          .updateActiveTime(_activeMinutes.toInt());
                    }
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_activeMinutes > 0 && _enabled) {
                      context
                          .read<ActiveTimeCubit>()
                          .updateActiveTime(_activeMinutes.toInt());
                      context.read<TimerBloc>().add(const TimerReset());
                      _enabled = false;
                    }
                  },
                  child: _enabled ? const Text('Submit') : const Icon(
                      Icons.lock),
                ),
              ],
            ));
      },
    );
  }
}

/// The [ActiveMinutes] widget is responsible for the display of earned active minutes.
class ActiveMinutes extends StatelessWidget {
  const ActiveMinutes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
          borderOnForeground: true,
          color: Theme
              .of(context)
              .cardColor,
          shadowColor: Theme
              .of(context)
              .shadowColor,
          elevation: 0,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Active Minutes",
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium,
                  softWrap: true,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    alignment: AlignmentDirectional.center,
                    width: 100.0,
                    height: 75.0,
                    color: Theme
                        .of(context)
                        .hoverColor,
                    // decoration: BoxDecoration(color: Theme.of(context).dialogBackgroundColor),
                    child: BlocBuilder<ActiveTimeCubit, int>(
                      builder: (context, state) {
                        return Text(state.toString(),
                            style: Theme
                                .of(context)
                                .textTheme
                                .headlineSmall);
                      },
                    ),
                  ),
                ),
                Text('All time active minutes',
                    style: Theme
                        .of(context)
                        .textTheme
                        .labelMedium),
              ],
            ),
          )),
    );
  }
}

/// The [ReminderDuration] widget is responsible for the display of the reminder duration.
class ReminderDuration extends StatelessWidget {
  const ReminderDuration({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text('Duration', style: Theme
            .of(context)
            .textTheme
            .titleMedium),
        BlocProvider.value(
          value: BlocProvider.of<TimerBloc>(context),
          child: const TimerText(),
        ),
        BlocProvider.value(
          value: BlocProvider.of<TimerBloc>(context),
          child: const Actions(),
        ),
      ],
    );
  }
}

/// The [Actions] widget is responsible for displaying the actions
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

/// The [TimerText] widget is responsible for displaying the remaining time.
class TimerText extends StatelessWidget {
  const TimerText({super.key});

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minutesStr =
    ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).toString().padLeft(2, '0');
    return Stack(alignment: AlignmentDirectional.center, children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
            height: 75,
            width: 100,
            alignment: AlignmentDirectional.center,
            decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .hoverColor,
            )),
      ),
      Text(
        '$minutesStr:$secondsStr',
        style: Theme
            .of(context)
            .textTheme
            .titleLarge,
      ),
    ]);
  }
}
