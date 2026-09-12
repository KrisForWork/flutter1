import 'package:flutter/material.dart';

import '../../data/app_texts.dart';

/// Закреплённая внизу панель с ФИО, группой и фото.
class StudentFooter extends StatelessWidget {
  const StudentFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final texts = AppTexts.instance;

    return Material(
      elevation: 8,
      color: scheme.surfaceContainerHighest,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              ClipOval(
                child: Image.asset(
                  texts.studentPhotoAsset,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => CircleAvatar(
                    radius: 24,
                    backgroundColor: scheme.primaryContainer,
                    child: Icon(Icons.person, color: scheme.onPrimaryContainer),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      texts.studentFullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${texts.studentGroupPrefix} ${texts.studentGroup}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
