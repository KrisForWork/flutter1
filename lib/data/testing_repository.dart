import 'package:injectable/injectable.dart';

import '../models/testing_type.dart';
import 'app_database.dart';

@lazySingleton
class TestingRepository {
  TestingRepository(this._db);

  final AppDatabase _db;

  Future<List<TestingType>> getAll() async {
    final rows = await _db.select(_db.testingTypes).get();
    return rows.map(_toModel).toList();
  }

  Future<int> insert(TestingType item) {
    return _db.into(_db.testingTypes).insert(_toCompanion(item));
  }

  Future<bool> update(int id, TestingType item) {
    return _db.update(_db.testingTypes).replace(
      TestingTypeRow(
        id: id,
        name: item.name,
        shortDescription: item.shortDescription,
        detailedDescription: item.detailedDescription,
        image: item.image,
        icon: item.icon,
      ),
    );
  }

  Future<int> delete(int id) {
    return (_db.delete(_db.testingTypes)..where((row) => row.id.equals(id)))
        .go();
  }

  TestingType _toModel(TestingTypeRow row) {
    return TestingType(
      name: row.name,
      shortDescription: row.shortDescription,
      detailedDescription: row.detailedDescription,
      image: row.image,
      icon: row.icon,
    );
  }

  TestingTypesCompanion _toCompanion(TestingType item) {
    return TestingTypesCompanion.insert(
      name: item.name,
      shortDescription: item.shortDescription,
      detailedDescription: item.detailedDescription,
      image: item.image,
      icon: item.icon,
    );
  }
}
