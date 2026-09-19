import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestingType {
  const TestingType({
    required this.name,
    required this.shortDescription,
    required this.detailedDescription,
    required this.image,
    required this.icon,
  });

  final String name;
  final String shortDescription;
  final String detailedDescription;
  final String image;
  final String icon;

  bool get isNetworkImage => image.startsWith('http');

  IconData get iconData => switch (icon) {
    'checklist' => Icons.checklist,
    'smart_toy' => Icons.smart_toy,
    'speed' => Icons.speed,
    'task_alt' => Icons.task_alt,
    'account_tree' => Icons.account_tree,
    _ => Icons.bug_report,
  };

  factory TestingType.fromJson(Map<String, dynamic> json) {
    return TestingType(
      name: json['name'] as String? ?? '',
      shortDescription: json['shortDescription'] as String? ?? '',
      detailedDescription: json['detailedDescription'] as String? ?? '',
      image: json['image'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );
  }
}

class TestingCatalog {
  TestingCatalog._();

  static const _assetPath = 'assets/data/testing_types.json';

  static String appTitle = 'ТестВик';
  static String topicTitle = 'Типы тестирования';
  static String topicDescription = '';
  static List<TestingType> items = const [];

  static Future<void> load() async {
    final raw = await rootBundle.loadString(_assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    appTitle = json['appTitle'] as String? ?? appTitle;
    topicTitle = json['topicTitle'] as String? ?? topicTitle;
    topicDescription = json['topicDescription'] as String? ?? '';
    final list = json['items'] as List<dynamic>? ?? const [];
    items = list
        .map(
          (item) => TestingType.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }
}
