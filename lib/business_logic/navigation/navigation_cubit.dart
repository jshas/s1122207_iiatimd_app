import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '/business_logic/navigation/constants/nav_bar_items.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState(BottomNavPage.timers, 1, 'Timers'));

  void getNavBarItem(BottomNavPage bottomNavPage) {
    switch (bottomNavPage) {
      case BottomNavPage.activities:
        emit(const NavigationState(BottomNavPage.activities, 0, 'Activities'));
        break;
      case BottomNavPage.timers:
        emit(const NavigationState(BottomNavPage.timers, 1, 'Timers'));
        break;
      case BottomNavPage.settings:
        emit(const NavigationState(BottomNavPage.settings, 2, 'Settings'));
        break;
    }
  }

  @override
  void onChange(Change<NavigationState> change) {
    super.onChange(change);
    if (kDebugMode) {
      print(change);
    }
  }
}