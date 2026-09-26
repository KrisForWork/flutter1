// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TestingTypesTable extends TestingTypes
    with TableInfo<$TestingTypesTable, TestingTypeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TestingTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shortDescriptionMeta = const VerificationMeta(
    'shortDescription',
  );
  @override
  late final GeneratedColumn<String> shortDescription = GeneratedColumn<String>(
    'short_description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailedDescriptionMeta =
      const VerificationMeta('detailedDescription');
  @override
  late final GeneratedColumn<String> detailedDescription =
      GeneratedColumn<String>(
        'detailed_description',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
    'image',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    shortDescription,
    detailedDescription,
    image,
    icon,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'testing_types';
  @override
  VerificationContext validateIntegrity(
    Insertable<TestingTypeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('short_description')) {
      context.handle(
        _shortDescriptionMeta,
        shortDescription.isAcceptableOrUnknown(
          data['short_description']!,
          _shortDescriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_shortDescriptionMeta);
    }
    if (data.containsKey('detailed_description')) {
      context.handle(
        _detailedDescriptionMeta,
        detailedDescription.isAcceptableOrUnknown(
          data['detailed_description']!,
          _detailedDescriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_detailedDescriptionMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
        _imageMeta,
        image.isAcceptableOrUnknown(data['image']!, _imageMeta),
      );
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TestingTypeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TestingTypeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      shortDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}short_description'],
      )!,
      detailedDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detailed_description'],
      )!,
      image: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
    );
  }

  @override
  $TestingTypesTable createAlias(String alias) {
    return $TestingTypesTable(attachedDatabase, alias);
  }
}

class TestingTypeRow extends DataClass implements Insertable<TestingTypeRow> {
  final int id;
  final String name;
  final String shortDescription;
  final String detailedDescription;
  final String image;
  final String icon;
  const TestingTypeRow({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.detailedDescription,
    required this.image,
    required this.icon,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['short_description'] = Variable<String>(shortDescription);
    map['detailed_description'] = Variable<String>(detailedDescription);
    map['image'] = Variable<String>(image);
    map['icon'] = Variable<String>(icon);
    return map;
  }

  TestingTypesCompanion toCompanion(bool nullToAbsent) {
    return TestingTypesCompanion(
      id: Value(id),
      name: Value(name),
      shortDescription: Value(shortDescription),
      detailedDescription: Value(detailedDescription),
      image: Value(image),
      icon: Value(icon),
    );
  }

  factory TestingTypeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TestingTypeRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      shortDescription: serializer.fromJson<String>(json['shortDescription']),
      detailedDescription: serializer.fromJson<String>(
        json['detailedDescription'],
      ),
      image: serializer.fromJson<String>(json['image']),
      icon: serializer.fromJson<String>(json['icon']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'shortDescription': serializer.toJson<String>(shortDescription),
      'detailedDescription': serializer.toJson<String>(detailedDescription),
      'image': serializer.toJson<String>(image),
      'icon': serializer.toJson<String>(icon),
    };
  }

  TestingTypeRow copyWith({
    int? id,
    String? name,
    String? shortDescription,
    String? detailedDescription,
    String? image,
    String? icon,
  }) => TestingTypeRow(
    id: id ?? this.id,
    name: name ?? this.name,
    shortDescription: shortDescription ?? this.shortDescription,
    detailedDescription: detailedDescription ?? this.detailedDescription,
    image: image ?? this.image,
    icon: icon ?? this.icon,
  );
  TestingTypeRow copyWithCompanion(TestingTypesCompanion data) {
    return TestingTypeRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      shortDescription: data.shortDescription.present
          ? data.shortDescription.value
          : this.shortDescription,
      detailedDescription: data.detailedDescription.present
          ? data.detailedDescription.value
          : this.detailedDescription,
      image: data.image.present ? data.image.value : this.image,
      icon: data.icon.present ? data.icon.value : this.icon,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TestingTypeRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('shortDescription: $shortDescription, ')
          ..write('detailedDescription: $detailedDescription, ')
          ..write('image: $image, ')
          ..write('icon: $icon')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, shortDescription, detailedDescription, image, icon);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TestingTypeRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.shortDescription == this.shortDescription &&
          other.detailedDescription == this.detailedDescription &&
          other.image == this.image &&
          other.icon == this.icon);
}

class TestingTypesCompanion extends UpdateCompanion<TestingTypeRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> shortDescription;
  final Value<String> detailedDescription;
  final Value<String> image;
  final Value<String> icon;
  const TestingTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.shortDescription = const Value.absent(),
    this.detailedDescription = const Value.absent(),
    this.image = const Value.absent(),
    this.icon = const Value.absent(),
  });
  TestingTypesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String shortDescription,
    required String detailedDescription,
    required String image,
    required String icon,
  }) : name = Value(name),
       shortDescription = Value(shortDescription),
       detailedDescription = Value(detailedDescription),
       image = Value(image),
       icon = Value(icon);
  static Insertable<TestingTypeRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? shortDescription,
    Expression<String>? detailedDescription,
    Expression<String>? image,
    Expression<String>? icon,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (shortDescription != null) 'short_description': shortDescription,
      if (detailedDescription != null)
        'detailed_description': detailedDescription,
      if (image != null) 'image': image,
      if (icon != null) 'icon': icon,
    });
  }

  TestingTypesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? shortDescription,
    Value<String>? detailedDescription,
    Value<String>? image,
    Value<String>? icon,
  }) {
    return TestingTypesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      shortDescription: shortDescription ?? this.shortDescription,
      detailedDescription: detailedDescription ?? this.detailedDescription,
      image: image ?? this.image,
      icon: icon ?? this.icon,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (shortDescription.present) {
      map['short_description'] = Variable<String>(shortDescription.value);
    }
    if (detailedDescription.present) {
      map['detailed_description'] = Variable<String>(detailedDescription.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TestingTypesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('shortDescription: $shortDescription, ')
          ..write('detailedDescription: $detailedDescription, ')
          ..write('image: $image, ')
          ..write('icon: $icon')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TestingTypesTable testingTypes = $TestingTypesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [testingTypes];
}

typedef $$TestingTypesTableCreateCompanionBuilder =
    TestingTypesCompanion Function({
      Value<int> id,
      required String name,
      required String shortDescription,
      required String detailedDescription,
      required String image,
      required String icon,
    });
typedef $$TestingTypesTableUpdateCompanionBuilder =
    TestingTypesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> shortDescription,
      Value<String> detailedDescription,
      Value<String> image,
      Value<String> icon,
    });

class $$TestingTypesTableFilterComposer
    extends Composer<_$AppDatabase, $TestingTypesTable> {
  $$TestingTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shortDescription => $composableBuilder(
    column: $table.shortDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detailedDescription => $composableBuilder(
    column: $table.detailedDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TestingTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $TestingTypesTable> {
  $$TestingTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shortDescription => $composableBuilder(
    column: $table.shortDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detailedDescription => $composableBuilder(
    column: $table.detailedDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get image => $composableBuilder(
    column: $table.image,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TestingTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TestingTypesTable> {
  $$TestingTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get shortDescription => $composableBuilder(
    column: $table.shortDescription,
    builder: (column) => column,
  );

  GeneratedColumn<String> get detailedDescription => $composableBuilder(
    column: $table.detailedDescription,
    builder: (column) => column,
  );

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);
}

class $$TestingTypesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TestingTypesTable,
          TestingTypeRow,
          $$TestingTypesTableFilterComposer,
          $$TestingTypesTableOrderingComposer,
          $$TestingTypesTableAnnotationComposer,
          $$TestingTypesTableCreateCompanionBuilder,
          $$TestingTypesTableUpdateCompanionBuilder,
          (
            TestingTypeRow,
            BaseReferences<_$AppDatabase, $TestingTypesTable, TestingTypeRow>,
          ),
          TestingTypeRow,
          PrefetchHooks Function()
        > {
  $$TestingTypesTableTableManager(_$AppDatabase db, $TestingTypesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TestingTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TestingTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TestingTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> shortDescription = const Value.absent(),
                Value<String> detailedDescription = const Value.absent(),
                Value<String> image = const Value.absent(),
                Value<String> icon = const Value.absent(),
              }) => TestingTypesCompanion(
                id: id,
                name: name,
                shortDescription: shortDescription,
                detailedDescription: detailedDescription,
                image: image,
                icon: icon,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String shortDescription,
                required String detailedDescription,
                required String image,
                required String icon,
              }) => TestingTypesCompanion.insert(
                id: id,
                name: name,
                shortDescription: shortDescription,
                detailedDescription: detailedDescription,
                image: image,
                icon: icon,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TestingTypesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TestingTypesTable,
      TestingTypeRow,
      $$TestingTypesTableFilterComposer,
      $$TestingTypesTableOrderingComposer,
      $$TestingTypesTableAnnotationComposer,
      $$TestingTypesTableCreateCompanionBuilder,
      $$TestingTypesTableUpdateCompanionBuilder,
      (
        TestingTypeRow,
        BaseReferences<_$AppDatabase, $TestingTypesTable, TestingTypeRow>,
      ),
      TestingTypeRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TestingTypesTableTableManager get testingTypes =>
      $$TestingTypesTableTableManager(_db, _db.testingTypes);
}
