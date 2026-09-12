import 'package:flutter/material.dart';

import 'state/directory_controller.dart';
import 'ui/directory_list_page.dart';
import 'data/app_texts.dart';

class DirectoryApp extends StatelessWidget {
  const DirectoryApp({super.key, required this.controller});

  final DirectoryController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppTexts.instance.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: DirectoryListPage(controller: controller),
    );
  }
}
