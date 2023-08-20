import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '/business_logic/navigation/constants/nav_bar_items.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState(NavbarItem.timers, 1, 'Timers'));

  void getNavBarItem(NavbarItem navbarItem) {
    switch (navbarItem) {
      case NavbarItem.activities:
        emit(const NavigationState(NavbarItem.activities, 0, 'Activities'));
        break;
      case NavbarItem.timers:
        emit(const NavigationState(NavbarItem.timers, 1, 'Timers'));
        break;
      case NavbarItem.settings:
        emit(const NavigationState(NavbarItem.settings, 2, 'Settings'));
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