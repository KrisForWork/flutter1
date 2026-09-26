import 'package:flutter/material.dart';

import '../models/testing_type.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/theme_mode_button.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.item});

  final TestingType item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          item.name,
          style: const TextStyle(fontFamily: 'Pacifico', fontSize: 22),
        ),
        actions: const [ThemeModeButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: item.isNetworkImage
                    ? Image.network(
                        item.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const _ImageFallback(),
                      )
                    : Image.asset(
                        item.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const _ImageFallback(),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                item.detailedDescription,
                style: const TextStyle(fontSize: 15, height: 1.45),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.cardTheme.color ?? theme.colorScheme.surface,
      child: const Center(child: Icon(Icons.image_not_supported, size: 48)),
    );
  }
}
