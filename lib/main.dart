import 'dart:async';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smallstep/business_logic/active_time/active_time_cubit.dart';
import 'package:smallstep/business_logic/authentication/authentication_bloc.dart';
import 'package:smallstep/business_logic/timer/timer_bloc.dart';
import 'package:smallstep/data/repositories/active_time_repository.dart';
import 'package:smallstep/data/repositories/activity_repository.dart';
import 'package:smallstep/data/repositories/authentication_repository.dart';
import 'package:smallstep/data/repositories/timer_repository.dart';
import 'package:smallstep/presentation/screen/base_screen.dart';

import 'business_logic/activity/activity_bloc.dart';
import 'business_logic/navigation/navigation_cubit.dart';
import 'business_logic/theme/theme_cubit.dart';
import 'data/data_providers/ticker.dart';
import 'data/repositories/theme_repository.dart';
import 'firebase_options.dart';
import 'presentation/theme/color_schemes.dart';

/// Used to connect to the firebase emulator
const bool useEmulator = false;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  if (useEmulator && kDebugMode) {
    await _connectToEmulator();
  }
  final themeRepository = ThemeRepository(sharedPreferences: sharedPreferences);
  final timerRepository = TimerRepository(sharedPreferences: sharedPreferences);
  final activeTimeRepository =
      ActiveTimeRepository(sharedPreferences: sharedPreferences);
  final activityRepository =
      FirebaseActivityRepository(firebaseFirestore: firebaseFirestore);
  final authenticationRepository = AuthenticationRepositoryImpl(
    firebaseAuth: FirebaseAuth.instance,
  );
  runApp(App(
    themeRepository: themeRepository,
    timerRepository: timerRepository,
    activeTimeRepository: activeTimeRepository,
    activityRepository: activityRepository,
    authenticationRepository: authenticationRepository,
  ));
}

class App extends StatelessWidget {
  const App(
      {super.key,
      required this.timerRepository,
      required this.themeRepository,
      required this.activeTimeRepository,
      required this.activityRepository,
      required this.authenticationRepository});

  final TimerRepository timerRepository;
  final ThemeRepository themeRepository;
  final ActiveTimeRepository activeTimeRepository;
  final ActivityRepository activityRepository;
  final AuthenticationRepositoryImpl authenticationRepository;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => themeRepository),
        RepositoryProvider(create: (context) => timerRepository),
        RepositoryProvider(create: (context) => activeTimeRepository),
        RepositoryProvider(create: (context) => activityRepository),
        RepositoryProvider(create: (context) => authenticationRepository),
      ],
      child: MultiBlocProvider(
          providers: [
            BlocProvider<NavigationCubit>(
              create: (context) => NavigationCubit(),
            ),
            BlocProvider<TimerBloc>(
              create: (context) => TimerBloc(
                ticker: const Ticker(),
                timerRepository: context.read<TimerRepository>(),
              )..getCurrentTimerItem(),
            ),
            BlocProvider<ThemeCubit>(
                create: (context) => ThemeCubit(
                      themeRepository: context.read<ThemeRepository>(),
                    )..getCurrentTheme()),
            BlocProvider<ActiveTimeCubit>(
                create: (context) => ActiveTimeCubit(
                      activeTimeRepository:
                          context.read<ActiveTimeRepository>(),
                    )..getCurrentActiveTime()),
            BlocProvider<ActivityBloc>(
                create: (context) => ActivityBloc(
                      activityRepository: context.read<ActivityRepository>(),
                    )),
            BlocProvider<AuthenticationBloc>(
                create: (context) => AuthenticationBloc(
                    context.read<AuthenticationRepositoryImpl>())
                  ..add(AuthenticationStarted())),
          ],
          child: BlocBuilder<ThemeCubit, ThemeState>(builder: (context, state) {
            return MaterialApp(
                title: 'Flutter Demo',
                themeMode: state.themeMode,
                theme: ThemeData(
                    colorScheme: lightColorScheme,
                    useMaterial3: true,
                    visualDensity: VisualDensity.adaptivePlatformDensity),
                darkTheme: ThemeData(
                    colorScheme: darkColorScheme,
                    useMaterial3: true,
                    visualDensity: VisualDensity.adaptivePlatformDensity),
                home: const BaseScreen(),
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
                onGenerateRoute: (settings) {
                  switch (settings.name) {
                    case '/':
                      return MaterialPageRoute(
                          builder: (context) => const BaseScreen());
                    default:
                      return MaterialPageRoute(
                          builder: (context) => const BaseScreen());
                  }
                });
          })),
    );
  }
}

// Settings for firebase emulator connection
Future _connectToEmulator() async {
  final host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  const authPort = 9099;
  const firestorePort = 8080;

  if (kDebugMode) {
    print("I am running on emulator");
  }

  // Assign emulator settings to Firebase instances
  await FirebaseAuth.instance.useAuthEmulator(host, authPort);
  FirebaseFirestore.instance.useFirestoreEmulator(host, firestorePort);
}
