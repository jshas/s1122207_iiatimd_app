import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smallstep/business_logic/theme/constants/theme_items.dart';

import '../../business_logic/theme/theme_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.title});

  final String title;


  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ThemeItem selection = ThemeItem.dark;

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) =>
          GridView.count(
            crossAxisCount: 1,
            children: [
              Flex(
                direction: Axis.vertical,
                children: [
                  ListTile(
                    titleAlignment: ListTileTitleAlignment.threeLine,
                    title: Text("Theme",
                        style: Theme.of(context).textTheme.bodyMedium),
                    trailing: SegmentedButton(segments: const [
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
                    ], selected: <ThemeItem>{selection},
                      onSelectionChanged: (Set<ThemeItem>selectedThemeItem) {
                        context.read<ThemeCubit>().setTheme(
                            selectedThemeItem.first);
                        selection = selectedThemeItem.first;
                      },
                    ),
                  )
                ],
              ),
              // Flex(
              //   direction: Axis.horizontal,
              //   children: [
              //     Flexible(
              //       flex: 1,
              //       fit: FlexFit.tight,
              //       child: ListTile(
              //         visualDensity: VisualDensity.adaptivePlatformDensity,
              //         title: Text("Reminder timer duration", style: Theme.of(context).textTheme.bodyLarge),
              //         trailing: SegmentedButton(segments: const [
              //           ButtonSegment<ThemeItem>(
              //               value: ThemeItem.light,
              //               enabled: true,
              //               icon: Icon(Icons.light_mode),
              //               label: Text("Light")),
              //           ButtonSegment<ThemeItem>(
              //               value: ThemeItem.dark,
              //               enabled: true,
              //               icon: Icon(Icons.dark_mode),
              //               label: Text("dark")),
              //           ButtonSegment<ThemeItem>(
              //               value: ThemeItem.system,
              //               enabled: true,
              //               icon: Icon(Icons.android),
              //               label: Text("Follow OS")),
              //         ], selected: <ThemeItem>{selection},
              //           onSelectionChanged: (Set<ThemeItem>selectedThemeItem) {
              //             context.read<ThemeCubit>().setTheme(
              //                 selectedThemeItem.first);
              //             selection = selectedThemeItem.first;
              //           },
              //         ),
              //       ),
              //     )
              //   ],
              // )
            ],

          ),

    );

  }
}
