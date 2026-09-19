import 'package:flutter/material.dart';

import '../data/auth_store.dart';
import '../data/testing_catalog.dart';
import '../routes.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      final next = AuthStore.loggedIn.value ? AppRoutes.home : AppRoutes.login;
      Navigator.pushReplacementNamed(context, next);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.menu_book, size: 96, color: Colors.black),
            const SizedBox(height: 16),
            Text(
              TestingCatalog.appTitle,
              style: const TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 36,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
