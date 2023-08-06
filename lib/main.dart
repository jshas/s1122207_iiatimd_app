import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smallstep/business_logic/timer/timer_bloc.dart';
import 'package:smallstep/data/repositories/timer_repository.dart';
import 'package:smallstep/presentation/screen/base_screen.dart';
import 'business_logic/theme/theme_cubit.dart';
import 'data/data_providers/ticker.dart';
import 'data/repositories/theme_repository.dart';
import 'presentation/theme/color_schemes.dart';
import 'business_logic/navigation/navigation_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final themeRepository = ThemeRepository(sharedPreferences: sharedPreferences);
  final timerRepository = TimerRepository(sharedPreferences: sharedPreferences);
  runApp(
      App(themeRepository: themeRepository, timerRepository: timerRepository));
}

class App extends StatelessWidget {
  const App(
      {super.key,
      required this.timerRepository,
      required this.themeRepository});

  final TimerRepository timerRepository;
  final ThemeRepository themeRepository;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => themeRepository,
        ),
        RepositoryProvider(
          create: (context) => timerRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<NavigationCubit>(
            create: (context) => NavigationCubit(),
          ),
          BlocProvider<TimerBloc>(
            create: (context) => TimerBloc(ticker: const Ticker(), timerRepository: context.read<TimerRepository>(),),
          ),
          BlocProvider<ThemeCubit>(
              create: (context) => ThemeCubit(
                    themeRepository: context.read<ThemeRepository>(),
                  )..getCurrentTheme())
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (_, state) {
            return MaterialApp(
              title: 'Flutter Demo',
              themeMode: state.themeMode,
              //
              theme:
                  ThemeData(colorScheme: lightColorScheme, useMaterial3: true, visualDensity: VisualDensity.adaptivePlatformDensity),
              darkTheme:
                  ThemeData(colorScheme: darkColorScheme, useMaterial3: true, visualDensity: VisualDensity.adaptivePlatformDensity),
              home: const BaseScreen(),
            );
          },
        ),
      ),
    );
  }
}
