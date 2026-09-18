import 'package:flutter/material.dart';

/// Простое приложение: один экран без скролла и переходов.
class DirectoryApp extends StatelessWidget {
  const DirectoryApp({super.key});

  static const appTitle = 'ТестВик';
  static const topicTitle = 'Типы тестирования';
  static const topicDescription =
      'Типы тестирования — это способы проверки программы: '
      'кто проверяет, что именно смотрят и с какой целью. '
      'Разные типы помогают найти разные ошибки.';

  static const topicExtra =
      'На практике типы комбинируют: сначала проверяют основные функции '
      '(функциональное), затем смотрят, как части системы работают вместе '
      '(интеграционное). Ручные проверки удобны для новых экранов и UX, '
      'автотесты — для повторяемой регрессии, нагрузочные — чтобы понять, '
      'как программа ведёт себя при большом объёме данных или запросов. '
      'Выбор типа зависит от цели проверки и этапа разработки.';

  static const testingTypes = <String>[
    'Ручное',
    'Автоматизированное',
    'Нагрузочное',
    'Функциональное',
    'Интеграционное',
  ];

  static const studentName = 'Ильичева Кристина Олеговна';
  static const studentGroup = 'ИКБО-60-23';
  static const profileAsset = 'assets/images/profile.png';
  static const topicImages = <String>[
    'assets/images/type_manual.png',
    'assets/images/type_automated.png',
    'assets/images/type_load.png',
    'assets/images/type_functional.png',
    'assets/images/type_integration.png',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  int _imageIndex = 0;

  void _nextImage() {
    setState(() {
      _imageIndex = (_imageIndex + 1) % DirectoryApp.topicImages.length;
    });
  }

  void _prevImage() {
    setState(() {
      _imageIndex =
          (_imageIndex - 1 + DirectoryApp.topicImages.length) %
          DirectoryApp.topicImages.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Полоса заголовка на всю ширину
            const ColoredBox(
              color: Color(0xFF8BE87A),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: Center(
                  child: Text(
                    DirectoryApp.appTitle,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF143816),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Название темы
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _InfoBox(
                child: Text(
                  DirectoryApp.topicTitle,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Краткое описание
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _InfoBox(
                child: Text(
                  DirectoryApp.topicDescription,
                  style: textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Картинка + список типов
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          GestureDetector(
                            onTap: _nextImage,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                DirectoryApp.topicImages[_imageIndex],
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => ColoredBox(
                                  color: scheme.secondaryContainer,
                                  child: const Center(
                                    child: Icon(Icons.image_not_supported),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: _prevImage,
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black12,
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.chevron_left),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: _nextImage,
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black12,
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.chevron_right),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 160,
                    child: _InfoBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final type in DirectoryApp.testingTypes)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                '• $type',
                                style: textTheme.bodyMedium,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Продолжение информации — высота по тексту
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: _InfoBox(
                child: Text(
                  DirectoryApp.topicExtra,
                  style: textTheme.bodyMedium,
                ),
              ),
            ),
            const Spacer(),
            // Подвал: фото и ФИО
            Material(
              elevation: 8,
              color: scheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        DirectoryApp.profileAsset,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => CircleAvatar(
                          radius: 24,
                          backgroundColor: scheme.primaryContainer,
                          child: Icon(
                            Icons.person,
                            color: scheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            DirectoryApp.studentName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Группа ${DirectoryApp.studentGroup}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: child,
    );
  }
}
