class DirectoryEntry {
  const DirectoryEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.softwareName = '',
    this.points = const <String>[],
    this.body = '',
    this.imageAsset = 'assets/images/article_checklist.png',
    this.isFavorite = false,
  });

  /// Заголовок статьи.
  final String id;
  final String title;

  /// Краткое описание ПО / темы.
  final String description;

  /// Тег-категория.
  final String category;

  /// Название ПО (программного обеспечения).
  final String softwareName;

  /// Краткие тезисы (3–5 пунктов), без отдельного заголовка в UI.
  final List<String> points;

  /// Подробное описание статьи по теме.
  final String body;

  /// Путь к картинке статьи.
  final String imageAsset;

  final bool isFavorite;

  DirectoryEntry copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? softwareName,
    List<String>? points,
    String? body,
    String? imageAsset,
    bool? isFavorite,
  }) {
    return DirectoryEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      softwareName: softwareName ?? this.softwareName,
      points: points ?? this.points,
      body: body ?? this.body,
      imageAsset: imageAsset ?? this.imageAsset,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
