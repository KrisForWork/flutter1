import 'package:flutter/services.dart';

import '../models/directory_entry.dart';
import '../models/student_profile.dart';
import 'app_texts.dart';
import 'article_assets_loader.dart';

export 'app_texts.dart' show DirectoryCategories;

/// In-memory directory. Pure Dart logic for unit and load tests.
class DirectoryRepository {
  DirectoryRepository({int startId = 1, String Function()? idGenerator})
    : _nextId = startId,
      _idGenerator = idGenerator;

  final List<DirectoryEntry> _entries = <DirectoryEntry>[];
  int _nextId;
  final String Function()? _idGenerator;

  List<DirectoryEntry> get entries =>
      List<DirectoryEntry>.unmodifiable(_entries);

  int get count => _entries.length;

  int get favoriteCount => _entries.where((entry) => entry.isFavorite).length;

  String _nextIdValue() {
    final custom = _idGenerator;
    if (custom != null) {
      return custom();
    }
    return '${_nextId++}';
  }

  /// Adds an entry. Empty title after trim is rejected (returns null).
  DirectoryEntry? add({
    required String title,
    String description = '',
    String category = DirectoryCategories.general,
    String softwareName = '',
    List<String> points = const <String>[],
    String body = '',
    String imageAsset = ArticleImages.checklist,
    bool isFavorite = false,
  }) {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      return null;
    }

    final entry = DirectoryEntry(
      id: _nextIdValue(),
      title: trimmedTitle,
      description: description.trim(),
      category: category,
      softwareName: softwareName.trim(),
      points: List<String>.unmodifiable(points),
      body: body.trim(),
      imageAsset: imageAsset,
      isFavorite: isFavorite,
    );
    _entries.add(entry);
    return entry;
  }

  bool remove(String id) {
    final index = _entries.indexWhere((entry) => entry.id == id);
    if (index < 0) {
      return false;
    }
    _entries.removeAt(index);
    return true;
  }

  DirectoryEntry? findById(String id) {
    for (final entry in _entries) {
      if (entry.id == id) {
        return entry;
      }
    }
    return null;
  }

  bool toggleFavorite(String id) {
    final index = _entries.indexWhere((entry) => entry.id == id);
    if (index < 0) {
      return false;
    }
    final current = _entries[index];
    _entries[index] = current.copyWith(isFavorite: !current.isFavorite);
    return true;
  }

  /// Combined filter: category, favorites-only, and title search (case-insensitive).
  List<DirectoryEntry> filter({
    String? category,
    bool favoritesOnly = false,
    String query = '',
  }) {
    final normalizedQuery = query.trim().toLowerCase();

    return _entries
        .where((entry) {
          final matchesCategory =
              category == null ||
              category.isEmpty ||
              entry.category == category;
          final matchesFavorite = !favoritesOnly || entry.isFavorite;
          final matchesQuery =
              normalizedQuery.isEmpty ||
              entry.title.toLowerCase().contains(normalizedQuery) ||
              entry.softwareName.toLowerCase().contains(normalizedQuery);
          return matchesCategory && matchesFavorite && matchesQuery;
        })
        .toList(growable: false);
  }

  void clear() => _entries.clear();

  /// Replaces catalogue with prepared entries (e.g. from assets).
  void replaceAll(Iterable<DirectoryEntry> entries) {
    clear();
    for (final entry in entries) {
      _entries.add(entry);
      final parsed = int.tryParse(entry.id);
      if (parsed != null && parsed >= _nextId) {
        _nextId = parsed + 1;
      }
    }
  }

  /// Loads all articles from `assets/articles/` via [index.json].
  Future<void> seedDemoData({AssetBundle? bundle}) async {
    final loaded = await ArticleAssetsLoader.loadAll(
      bundle: bundle,
      startId: 1,
    );
    replaceAll(loaded);
  }

  /// Mass generation for client load measurements.
  void generate(int n) {
    if (n <= 0) {
      return;
    }
    for (var i = 0; i < n; i++) {
      add(
        title: 'Запись ${count + 1}',
        softwareName: 'Генератор №$i',
        description: 'Автогенерированное описание №$i',
        category: DirectoryCategories.all[i % DirectoryCategories.all.length],
        imageAsset: ArticleImages.all[i % ArticleImages.all.length],
        points: <String>[
          'Пункт A для записи $i',
          'Пункт B для записи $i',
          'Пункт C для записи $i',
        ],
        body: 'Подробное автогенерированное описание записи №$i.',
      );
    }
  }
}
