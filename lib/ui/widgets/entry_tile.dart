import 'package:flutter/material.dart';

import '../../data/app_texts.dart';
import '../../models/directory_entry.dart';
import '../widget_keys.dart';

class EntryTile extends StatelessWidget {
  const EntryTile({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final DirectoryEntry entry;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.instance;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        key: WidgetKeys.entryTile(entry.id),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            entry.imageAsset,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              width: 56,
              height: 56,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: const Icon(Icons.article_outlined),
            ),
          ),
        ),
        title: Text(
          entry.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          [
            entry.category,
            if (entry.softwareName.isNotEmpty) entry.softwareName,
          ].join(' · '),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          key: WidgetKeys.entryFavoriteButton(entry.id),
          tooltip: entry.isFavorite
              ? texts.favoriteRemove
              : texts.favoriteTileAdd,
          icon: Icon(
            entry.isFavorite ? Icons.star : Icons.star_border,
            color: entry.isFavorite ? Colors.amber : null,
          ),
          onPressed: onToggleFavorite,
        ),
        onTap: onTap,
      ),
    );
  }
}
