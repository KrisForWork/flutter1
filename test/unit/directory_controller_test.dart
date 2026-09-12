import 'package:flutter_test/flutter_test.dart';
import 'package:test1/data/directory_repository.dart';
import 'package:test1/state/directory_controller.dart';

import '../helpers/test_assets.dart';

void main() {
  setUpAll(() async {
    await ensureAppAssetsLoaded();
  });

  DirectoryController buildController({DirectoryRepository? repository}) {
    return DirectoryController(repository: repository ?? DirectoryRepository());
  }

  group('DirectoryController', () {
    test('create seedDemo заполняет пустой репозиторий', () async {
      final controller = await DirectoryController.create(seedDemo: true);

      expect(controller.totalCount, greaterThanOrEqualTo(20));
      expect(controller.filteredEntries.length, controller.totalCount);
    });

    test('не сидирует, если seedDemo=false', () async {
      final controller = await DirectoryController.create(seedDemo: false);

      expect(controller.totalCount, 0);
      expect(controller.filteredEntries, isEmpty);
    });

    test('addEntry с валидным названием добавляет и сбрасывает ошибку', () {
      final controller = buildController();

      final ok = controller.addEntry(
        title: 'Новая',
        description: 'Текст',
        category: DirectoryCategories.testing,
      );

      expect(ok, isTrue);
      expect(controller.validationError, isNull);
      expect(controller.totalCount, 1);
      expect(controller.filteredEntries.single.title, 'Новая');
    });

    test('addEntry с пустым названием ставит validationError', () {
      final controller = buildController();

      final ok = controller.addEntry(title: '   ');

      expect(ok, isFalse);
      expect(controller.validationError, isNotNull);
      expect(controller.totalCount, 0);
    });

    test('фильтры контроллера влияют на filteredEntries', () {
      final repo = DirectoryRepository();
      repo.add(title: 'Alpha', category: DirectoryCategories.testing);
      repo.add(title: 'Beta', category: DirectoryCategories.flutter);
      final controller = buildController(repository: repo);

      controller.setCategoryFilter(DirectoryCategories.testing);

      expect(controller.filteredEntries, hasLength(1));
      expect(controller.filteredEntries.single.title, 'Alpha');
    });

    test('toggleFavorite и removeEntry обновляют состояние', () {
      final repo = DirectoryRepository();
      final entry = repo.add(title: 'X')!;
      final controller = buildController(repository: repo);

      expect(controller.toggleFavorite(entry.id), isTrue);
      expect(controller.entryById(entry.id)!.isFavorite, isTrue);
      expect(controller.removeEntry(entry.id), isTrue);
      expect(controller.totalCount, 0);
    });

    test('clearValidationError сбрасывает сообщение', () {
      final controller = buildController();
      controller.addEntry(title: '');
      expect(controller.validationError, isNotNull);

      controller.clearValidationError();
      expect(controller.validationError, isNull);
    });

    test('filteredEntries кэшируется между чтениями без изменений', () {
      final repo = DirectoryRepository()..add(title: 'A');
      final controller = buildController(repository: repo);

      final first = controller.filteredEntries;
      final second = controller.filteredEntries;
      expect(identical(first, second), isTrue);
    });

    test('generateEntries и clearAll пишут lastLoadOperation', () {
      final controller = buildController();

      controller.generateEntries(50);
      expect(controller.totalCount, 50);
      expect(controller.lastLoadOperation, contains('Генерация'));
      expect(controller.lastLoadDuration, isNotNull);

      controller.clearAll();
      expect(controller.totalCount, 0);
      expect(controller.lastLoadOperation, contains('Очистка'));
    });

    test('measureFilter фиксирует результат фильтра', () {
      final repo = DirectoryRepository();
      repo.generate(20);
      final controller = buildController(repository: repo);
      controller.setCategoryFilter(DirectoryCategories.testing);

      controller.measureFilter();

      expect(controller.lastLoadOperation, contains('Фильтр по'));
      expect(controller.lastLoadDuration, isNotNull);
    });
  });
}
