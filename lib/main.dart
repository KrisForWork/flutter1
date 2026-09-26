import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'cubit/theme_cubit.dart';
import 'data/auth_store.dart';
import 'di/injection.dart';
import 'models/testing_type.dart';
import 'pages/detail_page.dart';
import 'pages/home_page.dart';
import 'pages/loading_page.dart';
import 'pages/login_page.dart';
import 'pages/profile_page.dart';
import 'pages/register_page.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await AuthStore.load();
  runApp(
    BlocProvider.value(
      value: getIt<ThemeCubit>(),
      child: DirectoryApp(
        routes: {
          AppRoutes.loading: (_) => const LoadingPage(),
          AppRoutes.login: (_) => const LoginPage(),
          AppRoutes.register: (_) => const RegisterPage(),
          AppRoutes.home: (_) => const HomePage(),
          AppRoutes.profile: (_) => const ProfilePage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.detail &&
              settings.arguments is TestingType) {
            return MaterialPageRoute(
              builder: (_) =>
                  DetailPage(item: settings.arguments! as TestingType),
              settings: settings,
            );
          }
          return null;
        },
      ),
    ),
  );
}
