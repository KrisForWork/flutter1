import 'package:flutter/material.dart';

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
}
