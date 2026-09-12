import 'package:flutter/foundation.dart';

import '../data/directory_repository.dart';
import '../models/directory_entry.dart';
import '../data/app_texts.dart';

class DirectoryController extends ChangeNotifier {
  DirectoryController({
    DirectoryRepository? repository,
    @Deprecated('Use DirectoryController.create() to load assets')
    bool seedDemo = false,
  }) : _repository = repository ?? DirectoryRepository();

  /// Creates controller and optionally loads articles + UI texts from assets.
  static Future<DirectoryController> create({
    DirectoryRepository? repository,
    bool seedDemo = true,
    bool loadTexts = true,
  }) async {
    if (loadTexts && !AppTexts.isLoaded) {
      await AppTexts.load();
    }
    final repo = repository ?? DirectoryRepository();
    if (seedDemo && repo.count == 0) {
      await repo.seedDemoData();
    }
    return DirectoryController(repository: repo);
  }

  final DirectoryRepository _repository;

  String? _categoryFilter;
  bool _favoritesOnly = false;
  String _searchQuery = '';
  String? _validationError;
  Duration? _lastLoadDuration;
  String? _lastLoadOperation;

  List<DirectoryEntry> _cachedFiltered = const <DirectoryEntry>[];
  bool _filterCacheValid = false;

  DirectoryRepository get repository => _repository;

  String? get categoryFilter => _categoryFilter;

  bool get favoritesOnly => _favoritesOnly;

  String get searchQuery => _searchQuery;

  String? get validationError => _validationError;

  Duration? get lastLoadDuration => _lastLoadDuration;

  String? get lastLoadOperation => _lastLoadOperation;

  int get totalCount => _repository.count;

  int get favoriteCount => _repository.favoriteCount;

  /// Cached filtered view — recomputed once per data/filter change.
  List<DirectoryEntry> get filteredEntries {
    if (!_filterCacheValid) {
      _cachedFiltered = _repository.filter(
        category: _categoryFilter,
        favoritesOnly: _favoritesOnly,
        query: _searchQuery,
      );
      _filterCacheValid = true;
    }
    return _cachedFiltered;
  }

  int get visibleCount => filteredEntries.length;

  int get visibleFavoriteCount {
    var count = 0;
    for (final entry in filteredEntries) {
      if (entry.isFavorite) {
        count++;
      }
    }
    return count;
  }

  DirectoryEntry? entryById(String id) => _repository.findById(id);

  void _notifyDataChanged() {
    _filterCacheValid = false;
    notifyListeners();
  }

  void _notifyUiOnly() {
    notifyListeners();
  }

  bool addEntry({
    required String title,
    String description = '',
    String category = DirectoryCategories.general,
  }) {
    final entry = _repository.add(
      title: title,
      description: description,
      category: category,
    );

    if (entry == null) {
      _validationError = AppTexts.isLoaded
          ? AppTexts.instance.validationEmptyTitle
          : 'Введите название записи';
      _notifyUiOnly();
      return false;
    }

    _validationError = null;
    _notifyDataChanged();
    return true;
  }

  void clearValidationError() {
    if (_validationError == null) {
      return;
    }
    _validationError = null;
    _notifyUiOnly();
  }

  bool removeEntry(String id) {
    final removed = _repository.remove(id);
    if (removed) {
      _validationError = null;
      _notifyDataChanged();
    }
    return removed;
  }

  bool toggleFavorite(String id) {
    final changed = _repository.toggleFavorite(id);
    if (changed) {
      _notifyDataChanged();
    }
    return changed;
  }

  void setCategoryFilter(String? category) {
    _categoryFilter = category;
    _notifyDataChanged();
  }

  void setFavoritesOnly(bool value) {
    _favoritesOnly = value;
    _notifyDataChanged();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _notifyDataChanged();
  }

  void clearAll() {
    final stopwatch = Stopwatch()..start();
    _repository.clear();
    stopwatch.stop();
    _lastLoadDuration = stopwatch.elapsed;
    _lastLoadOperation = AppTexts.isLoaded
        ? AppTexts.instance.loadOpClear
        : 'Очистка справочника';
    _validationError = null;
    _notifyDataChanged();
  }

  void generateEntries(int count) {
    final stopwatch = Stopwatch()..start();
    _repository.generate(count);
    stopwatch.stop();
    _lastLoadDuration = stopwatch.elapsed;
    _lastLoadOperation = AppTexts.isLoaded
        ? AppTexts.instance.loadOpGenerate(count)
        : 'Генерация $count записей';
    _validationError = null;
    _notifyDataChanged();
  }

  /// Measures applying the current filter to the full in-memory list.
  void measureFilter() {
    final stopwatch = Stopwatch()..start();
    final result = _repository.filter(
      category: _categoryFilter,
      favoritesOnly: _favoritesOnly,
      query: _searchQuery,
    );
    stopwatch.stop();
    _lastLoadDuration = stopwatch.elapsed;
    _lastLoadOperation = AppTexts.isLoaded
        ? AppTexts.instance.loadOpFilter(
            filtered: result.length,
            total: _repository.count,
          )
        : 'Фильтр по ${result.length} из ${_repository.count} записей';
    _notifyUiOnly();
  }
}
