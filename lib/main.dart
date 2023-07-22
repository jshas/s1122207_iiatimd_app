import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smallstep/business_logic/timer/timer_bloc.dart';
import 'package:smallstep/presentation/screen/base_screen.dart';
import 'business_logic/theme/theme_cubit.dart';
import 'data/repositories/theme_repository.dart';
import 'presentation/theme/color_schemes.dart';
import 'business_logic/navigation/navigation_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeRepository = ThemeRepository(
    sharedPreferences: await SharedPreferences.getInstance(),
  );
  runApp(App(themeRepository: themeRepository));
}

class App extends StatelessWidget {
  const App({super.key, required this.themeRepository});

  final ThemeRepository themeRepository;


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: themeRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<NavigationCubit>(
            create: (context) => NavigationCubit(),
          ),
          BlocProvider<TimerBloc>(
            create: (context) => TimerBloc(),
          ),
          BlocProvider<ThemeCubit>(
              create: (context) => ThemeCubit(
                    themeRepository: context.read<ThemeRepository>(),
                  )..getCurrentTheme())
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              title: 'Flutter Demo',
              themeMode: state.themeMode,
              //
              theme: ThemeData(
                  colorScheme: lightColorScheme, useMaterial3: true),
              darkTheme: ThemeData(
                  colorScheme: darkColorScheme, useMaterial3: true),
              home: const BaseScreen(),
            );
          },
        ),
      ),
    );
  }
}
