import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'data/auth_store.dart';
import 'pages/login_page.dart';
import 'pages/profile_page.dart';

/// Один экран: заголовок темы, горизонтальный и вертикальный ListView.
class DirectoryApp extends StatelessWidget {
  const DirectoryApp({super.key});

  static const appTitle = 'ТестВик';
  static const topicTitle = 'Типы тестирования';
  static const topicDescription =
      'Типы тестирования — это способы проверки программы: '
      'кто проверяет, что именно смотрят и с какой целью. '
      'Разные типы помогают найти разные ошибки.';

  static const studentName = 'Ильичева Кристина Олеговна';
  static const studentGroup = 'ИКБО-60-23';

  static const topicImages = <String>[
    'assets/images/type_manual.png',
    'assets/images/type_automated.png',
    'assets/images/type_load.png',
    'assets/images/type_functional.png',
    'assets/images/type_integration.png',
  ];

  static const testingItems = <(IconData, String, String)>[
    (
      Icons.checklist,
      'Ручное',
      'Человек проходит сценарии по чек-листу и смотрит, как ведёт себя приложение. '
          'Удобно для новых экранов, UX и того, что автотесты не видят.',
    ),
    (
      Icons.smart_toy,
      'Автоматизированное',
      'Код сам проверяет логику и интерфейс: unit-тесты — отдельные функции, '
          'widget-тесты — экраны и кнопки. Подходит для повторяемой регрессии.',
    ),
    (
      Icons.speed,
      'Нагрузочное',
      'Смотрят, как программа ведёт себя при большом объёме данных или операций. '
          'Замеряют время, ищут тормоза списка и узкие места на клиенте.',
    ),
    (
      Icons.task_alt,
      'Функциональное',
      'Проверяют, что функции работают по требованиям: поиск, фильтры, добавление. '
          'Ответ на вопрос «делает ли программа то, что должна».',
    ),
    (
      Icons.account_tree,
      'Интеграционное',
      'Проверяют, как части системы работают вместе: экран, состояние и данные. '
          'Ошибка часто видна только на стыке модулей, а не в каждом по отдельности.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AuthStore.loggedIn,
      builder: (_, isLoggedIn, _) {
        return MaterialApp(
          key: ValueKey(isLoggedIn),
          title: appTitle,
          debugShowCheckedModeBanner: false,
          // Web: мышь и трекпад должны уметь скроллить ListView.
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
          home: isLoggedIn ? const _HomePage() : const LoginPage(),
        );
      },
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: Column(
        children: [
          const ColoredBox(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                width: double.infinity,
                height: 64,
                child: Center(
                  child: Text(
                    DirectoryApp.appTitle,
                    style: TextStyle(
                      fontFamily: 'Pacifico',
                      fontSize: 26,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ColoredBox(
              color: const Color(0xFFEEEEEE),
              child: Column(
              children: [
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _InfoBox(
                    child: Text(
                      DirectoryApp.topicTitle,
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _InfoBox(
                    child: Text(
                      DirectoryApp.testingItems.map((item) => item.$2).join(' · '),
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _InfoBox(
                    child: Text(
                      DirectoryApp.topicDescription,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        height: 1.35,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const SizedBox(height: 140, child: _HorizontalImages()),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    itemCount: DirectoryApp.testingItems.length,
                    itemBuilder: (context, index) {
                      final item = DirectoryApp.testingItems[index];
                      return Card(
                        color: Colors.white,
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          leading: Icon(item.$1, color: Colors.black),
                          title: Text(
                            item.$2,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            item.$3,
                            style: const TextStyle(color: Colors.black87),
                          ),
                          onTap: () {
                            final height = MediaQuery.sizeOf(context).height;
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                    item.$2,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.black,
                                  behavior: SnackBarBehavior.floating,
                                  dismissDirection: DismissDirection.up,
                                  margin: EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                    bottom: (height - 100).clamp(8.0, height - 8),
                                  ),
                                ),
                              );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            ),
          ),
          ColoredBox(
            color: Colors.white,
            child: SafeArea(
              top: false,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilePage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      ValueListenableBuilder<AppUser?>(
                        valueListenable: AuthStore.session,
                        builder: (_, user, _) => UserAvatar(
                          size: 48,
                          user: user,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ValueListenableBuilder<AppUser?>(
                              valueListenable: AuthStore.session,
                              builder: (_, user, _) {
                                return Text(
                                  user?.name ?? DirectoryApp.studentName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Группа ${DirectoryApp.studentGroup}',
                              style: TextStyle(fontSize: 13, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HorizontalImages extends StatefulWidget {
  const _HorizontalImages();

  @override
  State<_HorizontalImages> createState() => _HorizontalImagesState();
}

class _HorizontalImagesState extends State<_HorizontalImages> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        if (event is! PointerScrollEvent || !_controller.hasClients) return;
        final next =
            (_controller.offset + event.scrollDelta.dy + event.scrollDelta.dx)
                .clamp(
                  _controller.position.minScrollExtent,
                  _controller.position.maxScrollExtent,
                );
        _controller.jumpTo(next);
      },
      child: ListView.builder(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: DirectoryApp.topicImages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                DirectoryApp.topicImages[index],
                width: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const ColoredBox(
                  color: Color(0xFFEEEEEE),
                  child: SizedBox(
                    width: 200,
                    child: Icon(Icons.image_not_supported, color: Colors.black),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
