# Практическая работа. Управление темой приложения с помощью Cubit

## Цель работы

Научиться переключать светлую и тёмную тему приложения через Cubit, зарегистрировать его в DI-контейнере и подключить параметры тем в `MaterialApp`.

## Структура проекта

Вставить скриншот панели Project (папка `lib`).

Новые и изменённые файлы:

```
lib/
  cubit/theme_cubit.dart
  app_themes.dart
  widgets/theme_mode_button.dart
  app.dart
  main.dart
  di/injection.config.dart
```

## Экраны приложения

Вставить скриншот главной страницы в светлой теме.

Вставить скриншот той же страницы в тёмной теме.

Как получить скриншоты: запустить приложение, дойти до главной страницы, сделать снимок, затем переключить Switch справа в шапке и сделать второй снимок.

## Программный код

### Класс Cubit

Файл `lib/cubit/theme_cubit.dart`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void toggleTheme() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }
}
```

### Регистрация в DI

В `lib/di/injection.config.dart` Cubit регистрируется как singleton. Вызов `configureDependencies()` в `main` подключает этот контейнер.

```dart
gh.lazySingleton<_i321.ThemeCubit>(() => _i321.ThemeCubit());
```

### Параметры тем

Файл `lib/app_themes.dart`.

```dart
import 'package:flutter/material.dart';

class AppThemes {
  static final light = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFEEEEEE),
    colorScheme: const ColorScheme.light(
      primary: Colors.black,
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
    appBarTheme: const AppBarThemeData(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black, fontSize: 14),
      titleMedium: TextStyle(color: Colors.black),
      titleLarge: TextStyle(color: Colors.black),
    ),
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.black),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
      ),
    ),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      onPrimary: Colors.black,
      surface: Color(0xFF1E1E1E),
      onSurface: Colors.white,
    ),
    appBarTheme: const AppBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
      titleMedium: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
    ),
    cardTheme: const CardThemeData(
      color: Color(0xFF2C2C2C),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: const StadiumBorder(),
      ),
    ),
  );
}
```

### Переключение темы в UI

Файл `lib/widgets/theme_mode_button.dart`. Switch стоит в шапке главной страницы и в `AppBar` экранов «Профиль» и «Детали».

```dart
class ThemeModeButton extends StatelessWidget {
  const ThemeModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        return Switch(
          value: mode == ThemeMode.dark,
          onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
        );
      },
    );
  }
}
```

Фрагмент шапки главной страницы:

```dart
const Align(
  alignment: Alignment.centerRight,
  child: ThemeModeButton(),
),
```

Фрагмент `AppBar` профиля:

```dart
actions: const [ThemeModeButton()],
```

Подключение тем в `lib/app.dart`:

```dart
return BlocBuilder<ThemeCubit, ThemeMode>(
  builder: (context, themeMode) {
    return MaterialApp(
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: themeMode,
      // маршруты без изменений
    );
  },
);
```

### main.dart

```dart
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
```
