import 'package:flutter/material.dart';

import 'app.dart';
import 'data/auth_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthStore.load();
  runApp(const DirectoryApp());
}
