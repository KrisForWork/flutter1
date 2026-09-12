import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../data/app_texts.dart';
import '../widget_keys.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({
    super.key,
    required this.selectedCategory,
    required this.favoritesOnly,
    required this.onCategorySelected,
    required this.onFavoritesOnlyChanged,
  });

  final String? selectedCategory;
  final bool favoritesOnly;
  final ValueChanged<String?> onCategorySelected;
  final ValueChanged<bool> onFavoritesOnlyChanged;

  static const _labelStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );
  static const _chipPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 10,
  );

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.instance;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: true,
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
                PointerDeviceKind.stylus,
              },
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    key: WidgetKeys.filterCategoryAll,
                    label: Text(texts.filterAll, style: _labelStyle),
                    padding: _chipPadding,
                    selected: selectedCategory == null,
                    onSelected: (_) => onCategorySelected(null),
                  ),
                  const SizedBox(width: 10),
                  ...DirectoryCategories.all.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: FilterChip(
                        key: WidgetKeys.filterCategory(category),
                        label: Text(category, style: _labelStyle),
                        padding: _chipPadding,
                        selected: selectedCategory == category,
                        onSelected: (_) => onCategorySelected(category),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: FilterChip(
              key: WidgetKeys.filterFavorites,
              label: Text(texts.filterFavorites, style: _labelStyle),
              padding: _chipPadding,
              selected: favoritesOnly,
              onSelected: onFavoritesOnlyChanged,
              avatar: Icon(
                favoritesOnly ? Icons.star : Icons.star_border,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
