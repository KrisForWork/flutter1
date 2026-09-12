import 'package:flutter/foundation.dart';

/// Stable selectors for widget tests.
class WidgetKeys {
  static const entrySearchField = Key('entry_search_field');
  /// Совпадает с FAB «+» (верхней кнопки «Добавить» больше нет).
  static const entryAddButton = Key('open_add_page_button');
  static const entryList = Key('entry_list');
  static const entryEmptyState = Key('entry_empty_state');
  static const entryTitleField = Key('entry_title_field');
  static const entryDescriptionField = Key('entry_description_field');
  static const entryCategoryField = Key('entry_category_field');
  static const entrySubmitButton = Key('entry_submit_button');
  static const entryValidationError = Key('entry_validation_error');
  static const filterFavorites = Key('filter_favorites');
  static const filterCategoryAll = Key('filter_category_all');
  static const countersText = Key('counters_text');
  static const openLoadPageButton = Key('open_load_page_button');
  static const openAddPageButton = Key('open_add_page_button');
  static const detailsFavoriteButton = Key('details_favorite_button');
  static const detailsDeleteButton = Key('details_delete_button');
  static const loadGenerateButton = Key('load_generate_button');
  static const loadGenerate100 = Key('load_generate_100');
  static const loadGenerate1000 = Key('load_generate_1000');
  static const loadGenerate10000 = Key('load_generate_10000');
  static const loadClearButton = Key('load_clear_button');
  static const loadFilterButton = Key('load_filter_button');
  static const loadResultText = Key('load_result_text');

  static Key filterCategory(String category) =>
      Key('filter_category_$category');

  static Key entryTile(String id) => Key('entry_tile_$id');

  static Key entryFavoriteButton(String id) => Key('entry_favorite_button_$id');
}
