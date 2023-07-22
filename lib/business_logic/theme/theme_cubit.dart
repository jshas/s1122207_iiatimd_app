import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/theme_repository.dart';
import 'constants/theme_items.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({
    required ThemePersistence themeRepository,
  })  : _themeRepository = themeRepository,
        super(const ThemeState(ThemeItem.light, ThemeMode.light));

  final ThemePersistence _themeRepository;
  late StreamSubscription<ThemeItem> _themeSubscription;

  void getCurrentTheme() {
    // Since `getTheme()` returns a stream, we listen to the output
    _themeSubscription = _themeRepository.getTheme().listen(
      (themeName) {
        getThemeItem(themeName);
      },
    );
  }

  void getThemeItem(ThemeItem themeItem) {
    switch (themeItem) {
      case ThemeItem.light:
        emit(const ThemeState(ThemeItem.light, ThemeMode.light));
        break;
      case ThemeItem.dark:
        emit(const ThemeState(ThemeItem.dark, ThemeMode.dark));
        break;
      case ThemeItem.system:
        emit(const ThemeState(ThemeItem.system, ThemeMode.system));
        break;
    }
  }

  void setTheme(ThemeItem themeItem) {
    switch (themeItem) {
      case ThemeItem.light:
        _themeRepository.saveTheme(ThemeItem.light);
        break;
      case ThemeItem.dark:
        _themeRepository.saveTheme(ThemeItem.dark);
        break;
      case ThemeItem.system:
        _themeRepository.saveTheme(ThemeItem.system);
        break;
    }
  }

  @override
  Future<void> close() {
    _themeSubscription.cancel();
    _themeRepository.dispose();
    return super.close();
  }
}
