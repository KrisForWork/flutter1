import 'package:flutter/material.dart';

import '../data/app_texts.dart';
import '../state/directory_controller.dart';
import 'widget_keys.dart';
import 'widgets/student_footer.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({super.key, required this.controller});

  final DirectoryController controller;

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  int _selectedN = 100;

  String _formatDuration(Duration? duration) {
    final texts = AppTexts.instance;
    if (duration == null) {
      return texts.loadNotRun;
    }
    return texts.loadTime('${duration.inMilliseconds} мс');
  }

  String _labelFor(int n) {
    if (n >= 1000) {
      return '${n ~/ 1000} 000';
    }
    return '$n';
  }

  Key _nKey(int n) {
    switch (n) {
      case 100:
        return WidgetKeys.loadGenerate100;
      case 1000:
        return WidgetKeys.loadGenerate1000;
      case 10000:
        return WidgetKeys.loadGenerate10000;
      default:
        return Key('load_n_$n');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final texts = AppTexts.instance;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: Text(texts.loadPageTitle)),
          bottomNavigationBar: const StudentFooter(),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                texts.loadHeading,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(texts.loadHint),
              const SizedBox(height: 16),
              Text(texts.loadCount(controller.totalCount)),
              const SizedBox(height: 16),
              Text(
                texts.loadChooseN,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: <int>[100, 1000, 10000].map((n) {
                  return ChoiceChip(
                    key: _nKey(n),
                    label: Text(_labelFor(n)),
                    selected: _selectedN == n,
                    onSelected: (_) => setState(() => _selectedN = n),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              FilledButton(
                key: WidgetKeys.loadGenerateButton,
                onPressed: () => controller.generateEntries(_selectedN),
                child: Text(texts.loadGenerate(_labelFor(_selectedN))),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                key: WidgetKeys.loadClearButton,
                onPressed: controller.clearAll,
                child: Text(texts.loadClear),
              ),
              const SizedBox(height: 8),
              FilledButton.tonalIcon(
                key: WidgetKeys.loadFilterButton,
                onPressed: controller.measureFilter,
                icon: const Icon(Icons.filter_alt_outlined),
                label: Text(texts.loadFilter),
              ),
              const SizedBox(height: 24),
              Text(
                texts.loadResult,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                key: WidgetKeys.loadResultText,
                '${controller.lastLoadOperation ?? '—'}\n'
                '${_formatDuration(controller.lastLoadDuration)}',
              ),
            ],
          ),
        );
      },
    );
  }
}
