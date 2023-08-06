import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smallstep/presentation/screen/activities_screen.dart';
import 'package:smallstep/presentation/screen/settings_screen.dart';
import 'package:smallstep/presentation/screen/timers_screen.dart';

import '/business_logic/navigation/constants/nav_bar_items.dart';
import '/business_logic/navigation/navigation_cubit.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(state.title), centerTitle: true),
          bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
            builder: (context, state) {
              return NavigationBar(
                selectedIndex: state.index,
                destinations: const <Widget>[
                  NavigationDestination(
                    icon: Icon(
                      Icons.list,
                    ),
                    label: 'Activities',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.timer,
                    ),
                    label: 'Activity Timers',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.settings,
                    ),
                    label: 'Settings',
                  ),
                ],
                onDestinationSelected: (index) {
                  if (index == 0) {
                    BlocProvider.of<NavigationCubit>(context)
                        .getNavBarItem(NavbarItem.activities);
                  } else if (index == 1) {
                    BlocProvider.of<NavigationCubit>(context)
                        .getNavBarItem(NavbarItem.timers);
                  } else if (index == 2) {
                    BlocProvider.of<NavigationCubit>(context)
                        .getNavBarItem(NavbarItem.settings);
                  }
                },
              );
            },
          ),
          body: BlocBuilder<NavigationCubit, NavigationState>(
                builder: (context, state) {
                  if (state.navbarItem == NavbarItem.activities) {
                    return  const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ActivitiesScreen(title: "Activities"),
                    );
                  } else if (state.navbarItem == NavbarItem.timers) {
                    return const TimersScreen(title: "Timers");
                  } else if (state.navbarItem == NavbarItem.settings) {
                    return const SettingsScreen(title: "Settings");
                  }
                  return Container();
                }),
          );
      },
    );
  }
}