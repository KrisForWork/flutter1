import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_themes.dart';
import 'cubit/theme_cubit.dart';
import 'data/testing_data.dart';
import 'models/testing_type.dart';
import 'pages/detail_page.dart';
import 'routes.dart';

class DirectoryApp extends StatelessWidget {
  const DirectoryApp({super.key, required this.routes, this.onGenerateRoute});

  final Map<String, WidgetBuilder> routes;
  final RouteFactory? onGenerateRoute;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          title: appTitle,
          debugShowCheckedModeBanner: false,
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad,
            },
          ),
          theme: AppThemes.light,
          darkTheme: AppThemes.dark,
          themeMode: themeMode,
          initialRoute: AppRoutes.loading,
          routes: routes,
          onGenerateRoute: onGenerateRoute ?? _onGenerateRoute,
        );
      },
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    if (settings.name == AppRoutes.detail &&
        settings.arguments is TestingType) {
      return MaterialPageRoute(
        builder: (_) => DetailPage(item: settings.arguments! as TestingType),
        settings: settings,
      );
    }
    return null;
  }
}
