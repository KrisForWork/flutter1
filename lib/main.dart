import 'package:flutter/material.dart';

import 'app.dart';
import 'data/app_texts.dart';
import 'state/directory_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppTexts.load();
  final controller = await DirectoryController.create(seedDemo: true);
  runApp(DirectoryApp(controller: controller));
}
