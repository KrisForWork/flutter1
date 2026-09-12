import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test1/data/directory_repository.dart';
import 'package:test1/state/directory_controller.dart';
import 'package:test1/ui/load_page.dart';
import 'package:test1/ui/widget_keys.dart';

import '../helpers/test_assets.dart';

void main() {
  setUpAll(() async {
    await ensureAppAssetsLoaded();
  });

  testWidgets('генерация обновляет результат', (tester) async {
    final controller = DirectoryController(repository: DirectoryRepository());

    await tester.pumpWidget(MaterialApp(home: LoadPage(controller: controller)));
    await tester.pump();

    await tester.tap(find.byKey(WidgetKeys.loadGenerateButton));
    await tester.pump();

    expect(controller.totalCount, 100);
    expect(controller.lastLoadOperation, contains('Генерация'));
  });

  testWidgets('очистка справочника', (tester) async {
    final repository = DirectoryRepository()..generate(20);
    final controller = DirectoryController(repository: repository);

    await tester.pumpWidget(MaterialApp(home: LoadPage(controller: controller)));
    await tester.pump();

    await tester.tap(find.byKey(WidgetKeys.loadClearButton));
    await tester.pump();

    expect(controller.totalCount, 0);
    expect(controller.lastLoadOperation, contains('Очистка'));
  });
}
