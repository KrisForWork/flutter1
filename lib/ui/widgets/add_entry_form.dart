import 'package:flutter/material.dart';

import '../../data/app_texts.dart';
import '../widget_keys.dart';

class AddEntryForm extends StatefulWidget {
  const AddEntryForm({
    super.key,
    required this.onSubmit,
    this.validationError,
    this.onInputChanged,
  });

  final bool Function({
    required String title,
    required String description,
    required String category,
  })
  onSubmit;

  final String? validationError;

  /// Called when the user edits fields (e.g. to clear a validation message).
  final VoidCallback? onInputChanged;

  @override
  State<AddEntryForm> createState() => _AddEntryFormState();
}

class _AddEntryFormState extends State<AddEntryForm> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late String _category;

  @override
  void initState() {
    super.initState();
    _category = DirectoryCategories.general;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    final ok = widget.onSubmit(
      title: _titleController.text,
      description: _descriptionController.text,
      category: _category,
    );
    if (ok) {
      _titleController.clear();
      _descriptionController.clear();
      setState(() => _category = DirectoryCategories.general);
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.instance;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            key: WidgetKeys.entryTitleField,
            controller: _titleController,
            decoration: InputDecoration(
              labelText: texts.fieldTitle,
              border: const OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            onChanged: (_) => widget.onInputChanged?.call(),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 12),
          TextField(
            key: WidgetKeys.entryDescriptionField,
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: texts.fieldDescription,
              border: const OutlineInputBorder(),
            ),
            maxLines: 3,
            onChanged: (_) => widget.onInputChanged?.call(),
          ),
          const SizedBox(height: 12),
          InputDecorator(
            decoration: InputDecoration(
              labelText: texts.fieldCategory,
              border: const OutlineInputBorder(),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                key: WidgetKeys.entryCategoryField,
                value: _category,
                isExpanded: true,
                items: DirectoryCategories.all
                    .map(
                      (category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _category = value);
                    widget.onInputChanged?.call();
                  }
                },
              ),
            ),
          ),
          if (widget.validationError != null) ...[
            const SizedBox(height: 12),
            Text(
              widget.validationError!,
              key: WidgetKeys.entryValidationError,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 16),
          FilledButton.icon(
            key: WidgetKeys.entrySubmitButton,
            onPressed: _submit,
            icon: const Icon(Icons.add),
            label: Text(texts.submitAdd),
          ),
        ],
      ),
    );
  }
}
