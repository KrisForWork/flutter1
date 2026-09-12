import 'package:flutter/material.dart';

import '../data/app_texts.dart';
import '../state/directory_controller.dart';
import 'widget_keys.dart';
import 'widgets/student_footer.dart';

class EntryDetailsPage extends StatelessWidget {
  const EntryDetailsPage({
    super.key,
    required this.controller,
    required this.entryId,
  });

  final DirectoryController controller;
  final String entryId;

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.instance;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final entry = controller.entryById(entryId);
        final textTheme = Theme.of(context).textTheme;

        if (entry == null) {
          return Scaffold(
            appBar: AppBar(title: Text(texts.detailsArticle)),
            bottomNavigationBar: const StudentFooter(),
            body: Center(child: Text(texts.detailsNotFound)),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(entry.title),
            actions: [
              IconButton(
                key: WidgetKeys.detailsFavoriteButton,
                tooltip: entry.isFavorite
                    ? texts.favoriteRemove
                    : texts.favoriteAdd,
                icon: Icon(
                  entry.isFavorite ? Icons.star : Icons.star_border,
                  color: entry.isFavorite ? Colors.amber : null,
                ),
                onPressed: () => controller.toggleFavorite(entry.id),
              ),
              IconButton(
                key: WidgetKeys.detailsDeleteButton,
                tooltip: texts.delete,
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  controller.removeEntry(entry.id);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
          bottomNavigationBar: const StudentFooter(),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(texts.detailsHeading, style: textTheme.labelLarge),
                        const SizedBox(height: 4),
                        Text(entry.title, style: textTheme.headlineSmall),
                        const SizedBox(height: 16),
                        Text(texts.detailsSoftware, style: textTheme.labelLarge),
                        const SizedBox(height: 4),
                        Text(
                          entry.softwareName.isEmpty
                              ? texts.detailsSoftwareMissing
                              : entry.softwareName,
                          style: textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 128,
                        maxHeight: 128,
                      ),
                      child: Image.asset(
                        entry.imageAsset,
                        fit: BoxFit.contain,
                        alignment: Alignment.topRight,
                        errorBuilder: (_, _, _) => Container(
                          width: 96,
                          height: 96,
                          color: Theme.of(context)
                              .colorScheme
                              .primaryContainer,
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_not_supported, size: 36),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(texts.detailsDescription, style: textTheme.labelLarge),
              const SizedBox(height: 4),
              Text(
                entry.description.isEmpty
                    ? texts.detailsDescriptionMissing
                    : entry.description,
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Chip(label: Text(entry.category)),
              ),
              const SizedBox(height: 20),
              if (entry.points.isNotEmpty)
                ...entry.points.map(
                  (point) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('•  ', style: TextStyle(fontSize: 18)),
                        Expanded(
                          child: Text(point, style: textTheme.bodyLarge),
                        ),
                      ],
                    ),
                  ),
                ),
              if (entry.body.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(texts.detailsBody, style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(entry.body, style: textTheme.bodyLarge),
              ],
            ],
          ),
        );
      },
    );
  }
}
