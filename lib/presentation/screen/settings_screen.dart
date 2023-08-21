import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smallstep/business_logic/authentication/authentication_bloc.dart';
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
  ThemeItem _themeSelection = ThemeItem.dark;
  TimerItem _timerSelection = TimerItem.short;

  @override
  void initState() {
    super.initState();
    setState(() {
      _timerSelection = context.read<TimerBloc>().getTimerItem();
      _themeSelection = context.read<ThemeCubit>().state.theme;
    });
    // initTheme();
    // initTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          verticalDirection: VerticalDirection.down,
          children: [
            BlocBuilder<TimerBloc, TimerState>(
              builder: (context, state) {
                return Flex(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  direction:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? Axis.vertical
                          : Axis.horizontal,
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      width: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 400
                          : 290,
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reminder Duration',
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.start,
                          ),
                          const Spacer(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.info_outline_rounded, size: 16),
                              const SizedBox(width: 10),
                              Text(
                                'Changes applied after resetting timer.',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SegmentedButton(
                        style: Theme.of(context).segmentedButtonTheme.style,
                        segments: const [
                          ButtonSegment<TimerItem>(
                              value: TimerItem.short,
                              label: Text("15 minutes"),
                              icon: Icon(Icons.access_time),
                              enabled: true),
                          ButtonSegment<TimerItem>(
                              value: TimerItem.medium,
                              label: Text("30 minutes"),
                              icon: Icon(Icons.access_time),
                              enabled: true),
                          ButtonSegment<TimerItem>(
                              value: TimerItem.long,
                              label: Text("45 minutes"),
                              icon: Icon(Icons.access_time),
                              enabled: true),
                        ],
                        selected: <TimerItem>{_timerSelection},
                        emptySelectionAllowed: false,
                        onSelectionChanged: (Set<TimerItem> selectedTimerItem) {
                          context.read<TimerBloc>().add(
                              TimerSet(timerItem: selectedTimerItem.first));
                          setState(() {
                            _timerSelection = selectedTimerItem.first;
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) => Flex(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                direction:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? Axis.vertical
                        : Axis.horizontal,
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    width: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? 400
                        : 290,
                    height: 50,
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        "Theme",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SegmentedButton(
                      segments: const [
                        ButtonSegment<ThemeItem>(
                            value: ThemeItem.light,
                            enabled: true,
                            icon: Icon(Icons.light_mode),
                            label: Text("Light Mode")),
                        ButtonSegment<ThemeItem>(
                            value: ThemeItem.dark,
                            enabled: true,
                            icon: Icon(Icons.dark_mode),
                            label: Text("Dark Mode")),
                        ButtonSegment<ThemeItem>(
                            value: ThemeItem.system,
                            enabled: true,
                            icon: Icon(Icons.android),
                            label: Text("Follow OS")),
                      ],
                      selected: <ThemeItem>{_themeSelection},
                      showSelectedIcon: true,
                      onSelectionChanged: (Set<ThemeItem> selectedThemeItem) {
                        context
                            .read<ThemeCubit>()
                            .setTheme(selectedThemeItem.first);
                        _themeSelection = selectedThemeItem.first;
                      },
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                return Flex(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  direction:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? Axis.vertical
                          : Axis.horizontal,
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      width: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 400
                          : 290,
                      height: 50,
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Account",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    BlocBuilder<AuthenticationBloc, AuthenticationState>(
                        builder: (context, state) {
                      return _appBarLogin(context, state);
                    })
                  ],
                );
              },
            ),
          ],
        ));
  }
}

Flexible _appBarLogin(
  BuildContext context,
  AuthenticationState state,
) {
  return Flexible(
    flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
            style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.secondary)),
            onPressed: () {
              if (kDebugMode) {
                print({'onPressed': state.uid.toString()});
              }
              state.uid == null
                  ? {
                      context
                          .read<AuthenticationBloc>()
                          .add(AuthenticationLogoutRequested()),
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('You have been logged out.')))
                    }
                  : {
                      context
                          .read<AuthenticationBloc>()
                          .add(AuthenticationStarted()),
                      if (state.uid != null)
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'You have been logged in with uid ${state.uid}')),
                          )
                        },
                    };
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              verticalDirection: VerticalDirection.down,

              children: state.uid == null
                  ? [
                      const Icon(Icons.logout_rounded, size: 20),
                      const Text('Log out', style: TextStyle(fontSize: 14))
                    ]
                  : [
                      const Icon(Icons.login_rounded, size: 20),
                      const Text('Log in', style: TextStyle(fontSize: 14)),
                    ],
            )),
      ));
}
