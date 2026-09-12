import 'package:flutter_test/flutter_test.dart';
import 'package:test1/data/directory_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DirectoryRepository repository;

  setUp(() {
    repository = DirectoryRepository(startId: 1);
  });

  group('add', () {
    test('добавляет валидную запись', () {
      // Arrange & Act
      final entry = repository.add(
        title: 'Unit',
        description: 'Описание',
        category: DirectoryCategories.testing,
      );

      // Assert
      expect(entry, isNotNull);
      expect(entry!.id, '1');
      expect(entry.title, 'Unit');
      expect(entry.description, 'Описание');
      expect(entry.category, DirectoryCategories.testing);
      expect(entry.isFavorite, isFalse);
      expect(repository.count, 1);
    });

    test('обрезает пробелы у названия и описания', () {
      final entry = repository.add(
        title: '  Widget  ',
        description: '  desc  ',
        category: DirectoryCategories.flutter,
      );

      expect(entry, isNotNull);
      expect(entry!.title, 'Widget');
      expect(entry.description, 'desc');
    });

    test('отклоняет пустое название', () {
      final entry = repository.add(title: '');

      expect(entry, isNull);
      expect(repository.count, 0);
    });

    test('отклоняет название только из пробелов', () {
      final entry = repository.add(title: '   \t  ');

      expect(entry, isNull);
      expect(repository.count, 0);
    });

    test('поддерживает инжектируемый idGenerator', () {
      var counter = 0;
      final custom = DirectoryRepository(
        idGenerator: () => 'custom-${counter++}',
      );

      final first = custom.add(title: 'A');
      final second = custom.add(title: 'B');

      expect(first!.id, 'custom-0');
      expect(second!.id, 'custom-1');
    });
  });

  group('remove', () {
    test('удаляет существующую запись', () {
      final entry = repository.add(title: 'Удалить')!;

      expect(repository.remove(entry.id), isTrue);
      expect(repository.count, 0);
      expect(repository.findById(entry.id), isNull);
    });

    test('возвращает false для неизвестного id', () {
      repository.add(title: 'Есть');

      expect(repository.remove('missing'), isFalse);
      expect(repository.count, 1);
    });
  });

  group('toggleFavorite', () {
    test('переключает избранное туда и обратно', () {
      final entry = repository.add(title: 'Избранное')!;

      expect(repository.toggleFavorite(entry.id), isTrue);
      expect(repository.findById(entry.id)!.isFavorite, isTrue);
      expect(repository.favoriteCount, 1);

      expect(repository.toggleFavorite(entry.id), isTrue);
      expect(repository.findById(entry.id)!.isFavorite, isFalse);
      expect(repository.favoriteCount, 0);
    });

    test('возвращает false для неизвестного id', () {
      expect(repository.toggleFavorite('nope'), isFalse);
    });
  });

  group('filter', () {
    setUp(() {
      repository.add(
        title: 'Unit-тест',
        category: DirectoryCategories.testing,
      );
      repository.add(
        title: 'Widget-тест',
        category: DirectoryCategories.flutter,
      );
      final checklist = repository.add(
        title: 'Чек-лист',
        category: DirectoryCategories.testing,
      )!;
      repository.toggleFavorite(checklist.id);
      repository.add(
        title: 'Нагрузка',
        category: DirectoryCategories.general,
      );
    });

    test('фильтр по категории оставляет только нужные записи', () {
      final result = repository.filter(category: DirectoryCategories.testing);

      expect(result, hasLength(2));
      expect(
        result.every((e) => e.category == DirectoryCategories.testing),
        isTrue,
      );
    });

    test('пустая строка категории = без фильтра по категории', () {
      final result = repository.filter(category: '');

      expect(result, hasLength(4));
    });

    test('фильтр только избранные', () {
      final result = repository.filter(favoritesOnly: true);

      expect(result, hasLength(1));
      expect(result.single.title, 'Чек-лист');
    });

    test('поиск без учёта регистра', () {
      final upper = repository.filter(query: 'UNIT');
      final lower = repository.filter(query: 'unit');
      final mixed = repository.filter(query: '  UnIt  ');

      expect(upper, hasLength(1));
      expect(upper.single.title, 'Unit-тест');
      expect(lower.single.title, 'Unit-тест');
      expect(mixed.single.title, 'Unit-тест');
    });

    test('комбинация: категория + избранное + поиск', () {
      final result = repository.filter(
        category: DirectoryCategories.testing,
        favoritesOnly: true,
        query: 'чек',
      );

      expect(result, hasLength(1));
      expect(result.single.title, 'Чек-лист');
    });

    test('комбинация без совпадений даёт пустой список', () {
      final result = repository.filter(
        category: DirectoryCategories.flutter,
        favoritesOnly: true,
      );

      expect(result, isEmpty);
    });
  });

  group('clear / generate / seed', () {
    test('clear очищает все записи', () {
      repository.add(title: 'A');
      repository.add(title: 'B');

      repository.clear();

      expect(repository.count, 0);
      expect(repository.entries, isEmpty);
    });

    test('generate(n) создаёт ровно n записей', () {
      repository.generate(25);

      expect(repository.count, 25);
      expect(repository.entries.first.title, startsWith('Запись '));
    });

    test('generate добавляет к уже существующим', () {
      repository.add(title: 'Существующая');
      repository.generate(10);

      expect(repository.count, 11);
      expect(repository.entries.last.title, 'Запись 11');
    });

    test('generate с idGenerator даёт уникальные названия', () {
      var counter = 0;
      final custom = DirectoryRepository(
        idGenerator: () => 'id-${counter++}',
      );

      custom.generate(3);

      expect(
        custom.entries.map((e) => e.title).toList(),
        ['Запись 1', 'Запись 2', 'Запись 3'],
      );
      expect(custom.entries.map((e) => e.id).toList(), [
        'id-0',
        'id-1',
        'id-2',
      ]);
    });

    test('generate(0) и отрицательное n ничего не делают', () {
      repository.add(title: 'A');
      repository.generate(0);
      repository.generate(-5);

      expect(repository.count, 1);
    });

    test('seedDemoData заполняет демо-набор', () async {
      await repository.seedDemoData();

      expect(repository.count, greaterThanOrEqualTo(20));
      expect(
        repository.entries.map((e) => e.title),
        containsAll(<String>[
          'Unit-тестирование',
          'Widget-тесты во Flutter',
          'Чек-лист ручной проверки',
          'Нагрузка на клиенте',
          'Ручное тестирование',
          'Автоматизированное тестирование',
          'Нагрузочное тестирование',
          'Функциональное тестирование',
          'Интеграционное тестирование',
        ]),
      );
      expect(
        repository
            .filter(category: DirectoryCategories.testingTypes)
            .length,
        5,
      );
      expect(repository.favoriteCount, greaterThanOrEqualTo(1));
      expect(
        repository.entries.every((e) => e.points.isNotEmpty),
        isTrue,
      );
      expect(
        repository.entries.every(
          (e) => e.points.length >= 3 && e.points.length <= 5,
        ),
        isTrue,
      );
      expect(
        repository.entries.every((e) => e.body.isNotEmpty),
        isTrue,
      );
      expect(
        repository.entries.every((e) => e.softwareName.isNotEmpty),
        isTrue,
      );
    });

    test('seedDemoData сначала очищает справочник', () async {
      repository.add(title: 'Старая');
      await repository.seedDemoData();

      expect(repository.count, greaterThanOrEqualTo(20));
      expect(
        repository.entries.any((e) => e.title == 'Старая'),
        isFalse,
      );
    });
  });
}
