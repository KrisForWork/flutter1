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

  static const testingTypes = <String>[
    'Ручное тестирование',
    'Автоматизированное тестирование',
    'Нагрузочное тестирование',
    'Функциональное тестирование',
    'Интеграционное тестирование',
  ];

  static const studentName = 'Ильичева Кристина Олеговна';
  static const studentGroup = 'ИКБО-60-23';
  static const profileAsset = 'assets/images/profile.png';
  static const topicImageAsset = 'assets/images/article_checklist.png';

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

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Полоса заголовка на всю ширину
            Material(
              color: scheme.primaryContainer,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: Center(
                  child: Text(
                    DirectoryApp.appTitle,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.onPrimaryContainer,
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      DirectoryApp.topicImageAsset,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 110,
                        height: 110,
                        color: scheme.secondaryContainer,
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _InfoBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final type in DirectoryApp.testingTypes)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text('• $type', style: textTheme.bodyMedium),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
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
