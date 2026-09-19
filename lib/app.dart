import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'data/testing_catalog.dart';
import 'pages/detail_page.dart';
import 'routes.dart';

class DirectoryApp extends StatelessWidget {
  const DirectoryApp({
    super.key,
    required this.routes,
    this.onGenerateRoute,
  });

  final Map<String, WidgetBuilder> routes;
  final RouteFactory? onGenerateRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TestingCatalog.appTitle,
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
        },
      ),
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
      ),
      initialRoute: AppRoutes.loading,
      routes: routes,
      onGenerateRoute: onGenerateRoute ?? _onGenerateRoute,
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    if (settings.name == AppRoutes.detail && settings.arguments is TestingType) {
      return MaterialPageRoute(
        builder: (_) => DetailPage(item: settings.arguments! as TestingType),
        settings: settings,
      );
    }
    return null;
  }
}
