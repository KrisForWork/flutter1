import 'package:flutter_test/flutter_test.dart';
import 'package:test1/data/app_texts.dart';
import 'package:test1/data/directory_repository.dart';

/// Loads UI strings and (optionally) article assets for widget/unit tests.
Future<void> ensureAppAssetsLoaded({bool seedArticles = false}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  if (!AppTexts.isLoaded) {
    await AppTexts.load();
  }
  if (seedArticles) {
    // Caller seeds its own repository.
  }
}

Future<DirectoryRepository> seededRepository() async {
  await ensureAppAssetsLoaded();
  final repository = DirectoryRepository();
  await repository.seedDemoData();
  return repository;
}
