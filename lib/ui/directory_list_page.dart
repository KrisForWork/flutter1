import 'package:flutter/material.dart';

import '../data/app_texts.dart';
import '../state/directory_controller.dart';
import 'entry_details_page.dart';
import 'load_page.dart';
import 'widget_keys.dart';
import 'widgets/add_entry_form.dart';
import 'widgets/entry_tile.dart';
import 'widgets/filter_bar.dart';
import 'widgets/student_footer.dart';

class DirectoryListPage extends StatelessWidget {
  const DirectoryListPage({super.key, required this.controller});

  final DirectoryController controller;

  Future<void> _openAdd(BuildContext context) async {
    controller.clearValidationError();
    await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => _AddEntryRoute(controller: controller),
      ),
    );
  }

  void _openDetails(BuildContext context, String id) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => EntryDetailsPage(controller: controller, entryId: id),
      ),
    );
  }

  void _openLoad(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => LoadPage(controller: controller)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.instance;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final entries = controller.filteredEntries;
        final visibleFavorites = controller.visibleFavoriteCount;

        return Scaffold(
          appBar: AppBar(
            title: Text(texts.homeTitle),
            actions: [
              IconButton(
                key: WidgetKeys.openLoadPageButton,
                tooltip: texts.loadTooltip,
                icon: const Icon(Icons.speed_outlined),
                onPressed: () => _openLoad(context),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            key: WidgetKeys.openAddPageButton,
            tooltip: texts.addTooltip,
            onPressed: () => _openAdd(context),
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: const StudentFooter(),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  key: WidgetKeys.entrySearchField,
                  decoration: InputDecoration(
                    labelText: texts.searchLabel,
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: controller.setSearchQuery,
                ),
              ),
              FilterBar(
                selectedCategory: controller.categoryFilter,
                favoritesOnly: controller.favoritesOnly,
                onCategorySelected: controller.setCategoryFilter,
                onFavoritesOnlyChanged: controller.setFavoritesOnly,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    key: WidgetKeys.countersText,
                    texts.counters(
                      shown: entries.length,
                      total: controller.totalCount,
                      favorites: visibleFavorites,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: entries.isEmpty
                    ? Center(
                        child: Text(
                          texts.emptyState,
                          key: WidgetKeys.entryEmptyState,
                        ),
                      )
                    : ListView.builder(
                        key: WidgetKeys.entryList,
                        padding: const EdgeInsets.only(bottom: 88),
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          final entry = entries[index];
                          return EntryTile(
                            entry: entry,
                            onTap: () => _openDetails(context, entry.id),
                            onToggleFavorite: () =>
                                controller.toggleFavorite(entry.id),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddEntryRoute extends StatelessWidget {
  const _AddEntryRoute({required this.controller});

  final DirectoryController controller;

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.instance;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: Text(texts.addPageTitle)),
          bottomNavigationBar: const StudentFooter(),
          body: AddEntryForm(
            validationError: controller.validationError,
            onInputChanged: controller.clearValidationError,
            onSubmit:
                ({required title, required description, required category}) {
                  final ok = controller.addEntry(
                    title: title,
                    description: description,
                    category: category,
                  );
                  if (ok && context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                  return ok;
                },
          ),
        );
      },
    );
  }
}
