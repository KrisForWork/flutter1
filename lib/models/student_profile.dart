/// Данные автора приложения (закреплены внизу экрана).
class StudentProfile {
  static const fullName = 'Ильичева Кристина Олеговна';
  static const group = 'ИКБО-60-23';
  static const photoAsset = 'assets/images/profile.png';
}

/// Пути к иллюстрациям статей.
class ArticleImages {
  static const checklist = 'assets/images/article_checklist.png';
  static const auto = 'assets/images/article_auto.png';
  static const load = 'assets/images/article_load.png';
  static const system = 'assets/images/article_system.png';
  static const manual = 'assets/images/article_manual.png';
  static const flutter = 'assets/images/article_flutter.png';

  static const List<String> all = <String>[
    checklist,
    auto,
    load,
    system,
    manual,
    flutter,
  ];
}
