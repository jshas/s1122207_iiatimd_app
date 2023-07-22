import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smallstep/business_logic/theme/constants/theme_items.dart';
import 'package:smallstep/business_logic/timer/constants/timer_items.dart';

import '../../business_logic/theme/theme_cubit.dart';
import '../../business_logic/timer/timer_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.title});

  final String title;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ThemeItem themeSelection = ThemeItem.dark;
  TimerItem timerSelection = TimerItem.short;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        verticalDirection: VerticalDirection.down,
        children: [
          BlocBuilder<TimerBloc, TimerState>(
            builder: (context, state) {
             return Flex(
                direction:
                MediaQuery
                    .of(context)
                    .orientation == Orientation.portrait
                    ? Axis.vertical
                    : Axis.horizontal,
                children: [
                  const Align(alignment: AlignmentDirectional.centerStart ,child: Text("Reminder Timer")),
                  SegmentedButton(segments: const [
                    ButtonSegment(value: 10, label: Text("10 Seconds")),
                  ], selected: <TimerItem>{
                    timerSelection
                  }),
                ],
              );
            },
          ),
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) =>
            // Theme Selection
            Flex(
              direction:
              MediaQuery
                  .of(context)
                  .orientation == Orientation.portrait
                  ? Axis.vertical
                  : Axis.horizontal,
              children: [
                SizedBox(
                  child: Text("Theme",
                      textAlign: TextAlign.start,
                      style: Theme
                          .of(context)
                          .textTheme
                          .labelSmall),
                ),
                SegmentedButton(
                  segments: const [
                    ButtonSegment<ThemeItem>(
                        value: ThemeItem.light,
                        enabled: true,
                        icon: Icon(Icons.light_mode),
                        label: Text("Light")),
                    ButtonSegment<ThemeItem>(
                        value: ThemeItem.dark,
                        enabled: true,
                        icon: Icon(Icons.dark_mode),
                        label: Text("Night")),
                    ButtonSegment<ThemeItem>(
                        value: ThemeItem.system,
                        enabled: true,
                        icon: Icon(Icons.android),
                        label: Text("Follow OS")),
                  ],
                  selected: <ThemeItem>{themeSelection},
                  showSelectedIcon: false,
                  onSelectionChanged: (Set<ThemeItem> selectedThemeItem) {
                    context
                        .read<ThemeCubit>()
                        .setTheme(selectedThemeItem.first);
                    themeSelection = selectedThemeItem.first;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
