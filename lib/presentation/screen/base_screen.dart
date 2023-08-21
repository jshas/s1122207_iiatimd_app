import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smallstep/presentation/screen/activities_screen.dart';
import 'package:smallstep/presentation/screen/settings_screen.dart';
import 'package:smallstep/presentation/screen/timers_screen.dart';

import '/business_logic/navigation/constants/nav_bar_items.dart';
import '/business_logic/navigation/navigation_cubit.dart';
import '../components/add_activity_dialog.dart';

GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class BaseScreen extends StatelessWidget {
  const BaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          key: GlobalKey().currentState?.widget.key,
          appBar: AppBar(
            title: Text(state.title,
                style: Theme.of(context).textTheme.headlineSmall),
            centerTitle: true,
          ),
          floatingActionButton: (state.navbarItem == BottomNavPage.activities)
              ? FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    onAddActivityPressed(context);
                  },
                  child: const Icon(Icons.add),
                )
              : null,
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
                        .getNavBarItem(BottomNavPage.activities);
                  } else if (index == 1) {
                    BlocProvider.of<NavigationCubit>(context)
                        .getNavBarItem(BottomNavPage.timers);
                  } else if (index == 2) {
                    BlocProvider.of<NavigationCubit>(context)
                        .getNavBarItem(BottomNavPage.settings);
                  }
                },
              );
            },
          ),
          body: BlocBuilder<NavigationCubit, NavigationState>(
              builder: (context, state) {
            if (state.navbarItem == BottomNavPage.activities) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: ActivitiesScreen(title: "Activities"),
              );
            } else if (state.navbarItem == BottomNavPage.timers) {
              return const TimersScreen(title: "Timers");
            } else if (state.navbarItem == BottomNavPage.settings) {
              return const SettingsScreen(title: "Settings");
            }
            return const Center(child: Text('Error'));
          }),
        );
      },
    );
  }

  void onAddActivityPressed(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const AddActivityDialog();
        });
  }
}
