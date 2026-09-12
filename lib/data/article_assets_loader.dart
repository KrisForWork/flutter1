import 'package:flutter/services.dart';

import '../models/directory_entry.dart';
import '../models/student_profile.dart';
import 'dart:convert';

/// Loads catalogue articles from `assets/articles/*.json`.
class ArticleAssetsLoader {
  static const indexPath = 'assets/articles/index.json';

  /// Reads [index.json], then each article file in order.
  static Future<List<DirectoryEntry>> loadAll({
    AssetBundle? bundle,
    int startId = 1,
  }) async {
    final assetBundle = bundle ?? rootBundle;
    final indexRaw = await assetBundle.loadString(indexPath);
    final indexJson = jsonDecode(indexRaw) as Map<String, dynamic>;
    final files = (indexJson['articles'] as List<dynamic>)
        .map((e) => e.toString())
        .toList(growable: false);

    final entries = <DirectoryEntry>[];
    var nextId = startId;
    for (final fileName in files) {
      final raw = await assetBundle.loadString('assets/articles/$fileName');
      final map = jsonDecode(raw) as Map<String, dynamic>;
      entries.add(_fromJson(map, id: '${nextId++}'));
    }
    return entries;
  }

  static DirectoryEntry _fromJson(
    Map<String, dynamic> json, {
    required String id,
  }) {
    final points = (json['points'] as List<dynamic>? ?? const <dynamic>[])
        .map((e) => e.toString())
        .toList(growable: false);

    return DirectoryEntry(
      id: id,
      title: (json['title'] as String? ?? '').trim(),
      description: (json['description'] as String? ?? '').trim(),
      category: (json['category'] as String? ?? 'Общее').trim(),
      softwareName: (json['softwareName'] as String? ?? '').trim(),
      points: points,
      body: (json['body'] as String? ?? '').trim(),
      imageAsset: json['imageAsset'] as String? ?? ArticleImages.checklist,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }
}
