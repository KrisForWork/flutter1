import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test1/app.dart';
import 'package:test1/data/directory_repository.dart';
import 'package:test1/state/directory_controller.dart';
import 'package:test1/ui/widget_keys.dart';

import '../helpers/test_assets.dart';

void main() {
  setUpAll(() async {
    await ensureAppAssetsLoaded();
  });

  DirectoryController controllerWith(DirectoryRepository repository) {
    return DirectoryController(repository: repository);
  }

  Future<void> pumpApp(
    WidgetTester tester,
    DirectoryController controller,
  ) async {
    await tester.pumpWidget(DirectoryApp(controller: controller));
    await tester.pump();
  }

  DirectoryRepository sampleRepo() {
    final repository = DirectoryRepository();
    repository.add(
      title: 'Unit-тестирование',
      softwareName: 'JUnit',
      description: 'Описание unit',
      category: DirectoryCategories.auto,
      isFavorite: true,
      points: const ['A'],
    );
    repository.add(
      title: 'Widget-тесты во Flutter',
      softwareName: 'flutter_test',
      description: 'Описание widget',
      category: DirectoryCategories.flutter,
      points: const ['B'],
    );
    repository.add(
      title: 'Чек-лист ручной проверки',
      softwareName: 'Excel',
      description: 'Описание checklist',
      category: DirectoryCategories.manual,
      isFavorite: true,
      points: const ['C'],
    );
    return repository;
  }

  group('DirectoryListPage', () {
    testWidgets('пустое состояние показывает «Нет записей»', (tester) async {
      await pumpApp(tester, controllerWith(DirectoryRepository()));

      expect(find.text('Нет записей'), findsOneWidget);
      expect(find.textContaining('Показано: 0'), findsOneWidget);
      expect(find.textContaining('Ильичева Кристина Олеговна'), findsWidgets);
    });

    testWidgets('список показывает записи', (tester) async {
      final repository = sampleRepo();
      await pumpApp(tester, controllerWith(repository));

      expect(find.text('Справочник по тестированию'), findsOneWidget);
      expect(find.text('Unit-тестирование'), findsOneWidget);
      expect(find.textContaining('Всего: 3'), findsOneWidget);
    });

    testWidgets('статьи загружаются из assets', (tester) async {
      final repository = await seededRepository();
      expect(repository.count, greaterThanOrEqualTo(20));
      expect(
        repository.filter(category: DirectoryCategories.testingTypes).length,
        5,
      );
    });

    testWidgets('поиск фильтрует список', (tester) async {
      await pumpApp(tester, controllerWith(sampleRepo()));

      await tester.enterText(find.byKey(WidgetKeys.entrySearchField), 'UNIT');
      await tester.pump();

      expect(find.text('Unit-тестирование'), findsOneWidget);
      expect(find.text('Widget-тесты во Flutter'), findsNothing);
    });

    testWidgets('фильтр избранных', (tester) async {
      await pumpApp(tester, controllerWith(sampleRepo()));

      await tester.tap(find.byKey(WidgetKeys.filterFavorites));
      await tester.pump();

      expect(find.text('Чек-лист ручной проверки'), findsOneWidget);
      expect(find.text('Unit-тестирование'), findsOneWidget);
      expect(find.text('Widget-тесты во Flutter'), findsNothing);
    });

    testWidgets('FAB открывает форму', (tester) async {
      await pumpApp(tester, controllerWith(DirectoryRepository()));

      await tester.tap(find.byKey(WidgetKeys.openAddPageButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Новая запись'), findsOneWidget);
    });

    testWidgets('детали статьи', (tester) async {
      final repository = DirectoryRepository();
      final entry = repository.add(
        title: 'Детальная',
        softwareName: 'Demo Soft',
        description: 'Полный текст',
        category: DirectoryCategories.general,
        points: const ['Пункт один'],
      )!;

      await pumpApp(tester, controllerWith(repository));
      await tester.tap(find.byKey(WidgetKeys.entryTile(entry.id)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Название ПО'), findsOneWidget);
      expect(find.text('Demo Soft'), findsOneWidget);
      expect(find.text('Полный текст'), findsOneWidget);
    });
  });
}
