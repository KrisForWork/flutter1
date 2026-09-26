import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'testing_data.dart';

part 'app_database.g.dart';

@DataClassName('TestingTypeRow')
class TestingTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get shortDescription => text()();
  TextColumn get detailedDescription => text()();
  TextColumn get image => text()();
  TextColumn get icon => text()();
}

@lazySingleton
@DriftDatabase(tables: [TestingTypes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await _seed();
    },
    onUpgrade: (Migrator m, int from, int to) async {},
  );

  Future<void> _seed() async {
    for (final item in testingItems) {
      await into(testingTypes).insert(
        TestingTypesCompanion.insert(
          name: item.name,
          shortDescription: item.shortDescription,
          detailedDescription: item.detailedDescription,
          image: item.image,
          icon: item.icon,
        ),
      );
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    final folder = await getApplicationDocumentsDirectory();
    final file = File(p.join(folder.path, 'testvik.sqlite'));
    return NativeDatabase(file);
  });
}
