import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test1/data/directory_repository.dart';
import 'package:test1/ui/widget_keys.dart';
import 'package:test1/ui/widgets/filter_bar.dart';

import '../helpers/test_assets.dart';

void main() {
  setUpAll(() async {
    await ensureAppAssetsLoaded();
  });

  testWidgets('FilterBar вызывает колбэки категории и избранного', (
    tester,
  ) async {
    String? selectedCategory;
    var favoritesOnly = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return FilterBar(
                selectedCategory: selectedCategory,
                favoritesOnly: favoritesOnly,
                onCategorySelected: (value) {
                  setState(() => selectedCategory = value);
                },
                onFavoritesOnlyChanged: (value) {
                  setState(() => favoritesOnly = value);
                },
              );
            },
          ),
        ),
      ),
    );

    final flutterChip = find.byKey(
      WidgetKeys.filterCategory(DirectoryCategories.flutter),
    );
    await tester.ensureVisible(flutterChip);
    await tester.pump();
    await tester.tap(flutterChip);
    await tester.pump();
    expect(selectedCategory, DirectoryCategories.flutter);

    await tester.tap(find.byKey(WidgetKeys.filterFavorites));
    await tester.pump();
    expect(favoritesOnly, isTrue);

    await tester.ensureVisible(find.byKey(WidgetKeys.filterCategoryAll));
    await tester.tap(find.byKey(WidgetKeys.filterCategoryAll));
    await tester.pump();
    expect(selectedCategory, isNull);
  });
}
