import 'package:flutter_test/flutter_test.dart';
import 'package:test1/data/directory_repository.dart';

/// Клиентские нагрузочные замеры generate/filter без UI.
void main() {
  final timings = <String, int>{};

  tearDownAll(() {
    // ignore: avoid_print
    print('--- LOAD TIMINGS (ms) ---');
    timings.forEach((key, value) {
      // ignore: avoid_print
      print('$key: $value');
    });
  });

  for (final n in <int>[100, 1000, 10000]) {
    test('generate($n) завершается и даёт ровно $n записей', () {
      // Arrange
      final repository = DirectoryRepository();
      final stopwatch = Stopwatch();

      // Act
      stopwatch.start();
      repository.generate(n);
      stopwatch.stop();

      // Assert
      expect(repository.count, n);
      timings['generate_$n'] = stopwatch.elapsedMilliseconds;
      expect(stopwatch.elapsedMilliseconds, lessThan(60000));
    }, timeout: const Timeout(Duration(minutes: 2)));

    test('filter после generate($n) завершается', () {
      // Arrange
      final repository = DirectoryRepository()..generate(n);
      final stopwatch = Stopwatch();

      // Act
      stopwatch.start();
      final filtered = repository.filter(
        category: DirectoryCategories.testing,
        query: 'Запись',
      );
      stopwatch.stop();

      // Assert — категории циклом; «Тестирование» = индекс 0 из 7
      expect(filtered, isNotEmpty);
      expect(filtered.length, (n + DirectoryCategories.all.length - 1) ~/
          DirectoryCategories.all.length);
      expect(
        filtered.every((e) => e.category == DirectoryCategories.testing),
        isTrue,
      );
      timings['filter_$n'] = stopwatch.elapsedMilliseconds;
      expect(stopwatch.elapsedMilliseconds, lessThan(30000));
    }, timeout: const Timeout(Duration(minutes: 2)));
  }
}
