import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/student_profile.dart';

/// UI strings and student profile loaded from `assets/texts/ui.json`.
class AppTexts {
  AppTexts._(this._map);

  final Map<String, dynamic> _map;

  static AppTexts? _instance;

  static AppTexts get instance {
    final value = _instance;
    if (value == null) {
      throw StateError('AppTexts.load() must be called before use');
    }
    return value;
  }

  static bool get isLoaded => _instance != null;

  static Future<AppTexts> load({AssetBundle? bundle}) async {
    final assetBundle = bundle ?? rootBundle;
    final raw = await assetBundle.loadString('assets/texts/ui.json');
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final texts = AppTexts._(map);
    _instance = texts;
    return texts;
  }

  /// For unit/widget tests that need strings without async bootstrap.
  static void loadForTest(Map<String, dynamic> map) {
    _instance = AppTexts._(map);
  }

  static void resetForTest() => _instance = null;

  String _s(String key, [String fallback = '']) =>
      (_map[key] as String?) ?? fallback;

  String get appName => _s('appName', 'ТестВик');
  String get homeTitle => _s('homeTitle', 'Справочник по тестированию');
  String get searchLabel => _s('searchLabel', 'Поиск по названию');
  String get emptyState => _s('emptyState', 'Нет записей');
  String get filterAll => _s('filterAll', 'Все');
  String get filterFavorites => _s('filterFavorites', 'Только избранные');
  String get addTooltip => _s('addTooltip', 'Добавить запись');
  String get addPageTitle => _s('addPageTitle', 'Новая запись');
  String get fieldTitle => _s('fieldTitle', 'Название');
  String get fieldDescription => _s('fieldDescription', 'Описание');
  String get fieldCategory => _s('fieldCategory', 'Категория');
  String get submitAdd => _s('submitAdd', 'Добавить');
  String get validationEmptyTitle =>
      _s('validationEmptyTitle', 'Введите название записи');
  String get loadPageTitle => _s('loadPageTitle', 'Нагрузка');
  String get loadHeading =>
      _s('loadHeading', 'Клиентское нагрузочное тестирование');
  String get loadHint => _s(
    'loadHint',
    'Генерация записей в памяти и замер фильтра на этом устройстве (без сервера).',
  );
  String get loadChooseN => _s('loadChooseN', 'Количество записей (N)');
  String get loadClear => _s('loadClear', 'Очистить справочник');
  String get loadFilter =>
      _s('loadFilter', 'Применить фильтр к большому списку');
  String get loadResult => _s('loadResult', 'Результат');
  String get loadNotRun => _s('loadNotRun', 'Ещё не запускалось');
  String get detailsHeading => _s('detailsHeading', 'Заголовок');
  String get detailsSoftware => _s('detailsSoftware', 'Название ПО');
  String get detailsSoftwareMissing =>
      _s('detailsSoftwareMissing', 'Не указано');
  String get detailsDescription => _s('detailsDescription', 'Описание ПО');
  String get detailsDescriptionMissing =>
      _s('detailsDescriptionMissing', 'Описание отсутствует');
  String get detailsBody => _s('detailsBody', 'Подробное описание');
  String get detailsNotFound => _s('detailsNotFound', 'Запись не найдена');
  String get detailsArticle => _s('detailsArticle', 'Статья');
  String get favoriteAdd => _s('favoriteAdd', 'В избранное');
  String get favoriteRemove => _s('favoriteRemove', 'Убрать из избранного');
  String get favoriteTileAdd =>
      _s('favoriteTileAdd', 'Добавить в избранное');
  String get delete => _s('delete', 'Удалить');
  String get loadTooltip => _s('loadTooltip', 'Нагрузка');
  String get studentGroupPrefix => _s('studentGroupPrefix', 'Группа');

  String counters({
    required int shown,
    required int total,
    required int favorites,
  }) {
    return _s(
      'counters',
      'Показано: {shown} · Всего: {total} · Избранных: {favorites}',
    )
        .replaceAll('{shown}', '$shown')
        .replaceAll('{total}', '$total')
        .replaceAll('{favorites}', '$favorites');
  }

  String loadCount(int count) => _s('loadCount', 'Сейчас в справочнике: {count} записей')
      .replaceAll('{count}', '$count');

  String loadGenerate(String n) =>
      _s('loadGenerate', 'Сгенерировать {n} записей').replaceAll('{n}', n);

  String loadOpGenerate(int count) => _s(
    'loadOpGenerate',
    'Генерация {count} записей',
  ).replaceAll('{count}', '$count');

  String get loadOpClear => _s('loadOpClear', 'Очистка справочника');

  String loadOpFilter({required int filtered, required int total}) => _s(
    'loadOpFilter',
    'Фильтр по {filtered} из {total} записей',
  )
      .replaceAll('{filtered}', '$filtered')
      .replaceAll('{total}', '$total');

  String loadTime(String ms) =>
      _s('loadTime', 'Время: {ms}').replaceAll('{ms}', ms);

  List<String> get categories {
    final list = _map['categories'] as List<dynamic>?;
    if (list == null || list.isEmpty) {
      return DirectoryCategories.defaults;
    }
    return list.map((e) => e.toString()).toList(growable: false);
  }

  String get studentFullName {
    final student = _map['student'] as Map<String, dynamic>?;
    return student?['fullName'] as String? ?? StudentProfile.fullName;
  }

  String get studentGroup {
    final student = _map['student'] as Map<String, dynamic>?;
    return student?['group'] as String? ?? StudentProfile.group;
  }

  String get studentPhotoAsset {
    final student = _map['student'] as Map<String, dynamic>?;
    return student?['photoAsset'] as String? ?? StudentProfile.photoAsset;
  }
}

/// Категории (теги). Источник истины для фильтров — ui.json после загрузки.
class DirectoryCategories {
  static const testingTypes = 'Типы тестирования';
  static const testing = 'Тестирование';
  static const manual = 'Ручные тесты';
  static const auto = 'Автотесты';
  static const load = 'Нагрузочное тестирование';
  static const systems = 'Системы тестирования';
  static const flutter = 'Flutter';
  static const general = 'Общее';

  static List<String> get all =>
      AppTexts.isLoaded ? AppTexts.instance.categories : defaults;

  static const List<String> defaults = <String>[
    testingTypes,
    testing,
    manual,
    auto,
    load,
    systems,
    flutter,
    general,
  ];
}
