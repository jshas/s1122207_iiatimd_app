part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final ThemeItem theme;
  final ThemeMode themeMode;
  const ThemeState(this.theme, this.themeMode);


  @override
  List<Object> get props => [theme, themeMode];
}
