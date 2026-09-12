import 'package:flutter_test/flutter_test.dart';
import 'package:test1/models/directory_entry.dart';

void main() {
  group('DirectoryEntry', () {
    test('хранит все поля', () {
      const entry = DirectoryEntry(
        id: '1',
        title: 'Unit-тест',
        description: 'Описание',
        category: 'Тестирование',
        softwareName: 'JUnit',
        points: <String>['A', 'B'],
        body: 'Подробный текст',
        imageAsset: 'assets/images/article_auto.png',
        isFavorite: true,
      );

      expect(entry.id, '1');
      expect(entry.title, 'Unit-тест');
      expect(entry.description, 'Описание');
      expect(entry.category, 'Тестирование');
      expect(entry.softwareName, 'JUnit');
      expect(entry.points, <String>['A', 'B']);
      expect(entry.body, 'Подробный текст');
      expect(entry.imageAsset, 'assets/images/article_auto.png');
      expect(entry.isFavorite, isTrue);
    });

    test('isFavorite по умолчанию false', () {
      const entry = DirectoryEntry(
        id: '2',
        title: 'Запись',
        description: '',
        category: 'Общее',
      );

      expect(entry.isFavorite, isFalse);
      expect(entry.softwareName, '');
      expect(entry.points, isEmpty);
      expect(entry.body, '');
    });

    test('copyWith меняет только указанные поля', () {
      const original = DirectoryEntry(
        id: '10',
        title: 'Старое',
        description: 'Desc',
        category: 'Flutter',
        softwareName: 'X',
        points: <String>['1'],
        body: 'Body',
        isFavorite: false,
      );

      final updated = original.copyWith(title: 'Новое', isFavorite: true);

      expect(updated.id, '10');
      expect(updated.title, 'Новое');
      expect(updated.description, 'Desc');
      expect(updated.category, 'Flutter');
      expect(updated.softwareName, 'X');
      expect(updated.points, <String>['1']);
      expect(updated.body, 'Body');
      expect(updated.isFavorite, isTrue);
      expect(original.title, 'Старое');
      expect(original.isFavorite, isFalse);
    });

    test('copyWith без аргументов возвращает эквивалентную копию', () {
      const original = DirectoryEntry(
        id: '3',
        title: 'A',
        description: 'B',
        category: 'C',
        isFavorite: true,
      );

      final copy = original.copyWith();

      expect(copy.id, original.id);
      expect(copy.title, original.title);
      expect(copy.description, original.description);
      expect(copy.category, original.category);
      expect(copy.isFavorite, original.isFavorite);
    });
  });
}
