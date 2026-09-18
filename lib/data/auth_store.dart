import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUser {
  AppUser({
    required this.name,
    required this.email,
    required this.password,
  });

  String name;
  String email;
  String password;

  Map<String, String> toJson() => {
    'name': name,
    'email': email,
    'password': password,
  };

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
    );
  }
}

class AuthStore {
  AuthStore._();

  static const _usersKey = 'auth_users';
  static const _sessionKey = 'auth_session_email';

  static final List<AppUser> _users = [];
  static final session = ValueNotifier<AppUser?>(null);
  static final loggedIn = ValueNotifier<bool>(false);

  static AppUser? get current => session.value;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _users
      ..clear()
      ..addAll(_decodeUsers(prefs.getString(_usersKey)));

    final email = prefs.getString(_sessionKey);
    if (email == null) return;
    for (final user in _users) {
      if (user.email == email) {
        session.value = user;
        loggedIn.value = true;
        return;
      }
    }
  }

  static void _setUser(AppUser? user) {
    session.value = user;
    loggedIn.value = user != null;
    _save();
  }

  static Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _usersKey,
      jsonEncode(_users.map((user) => user.toJson()).toList()),
    );
    final email = session.value?.email;
    if (email == null) {
      await prefs.remove(_sessionKey);
    } else {
      await prefs.setString(_sessionKey, email);
    }
  }

  static List<AppUser> _decodeUsers(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((item) => AppUser.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  static String? register({
    required String name,
    required String email,
    required String password,
  }) {
    final key = email.trim().toLowerCase();
    if (_users.any((user) => user.email == key)) {
      return 'Этот email уже зарегистрирован';
    }
    final user = AppUser(
      name: name.trim(),
      email: key,
      password: password,
    );
    _users.add(user);
    _setUser(user);
    return null;
  }

  static String? login({
    required String email,
    required String password,
  }) {
    final key = email.trim().toLowerCase();
    for (final user in _users) {
      if (user.email != key) continue;
      if (user.password != password) {
        return 'Неверный пароль';
      }
      _setUser(user);
      return null;
    }
    return 'Пользователь не найден. Сначала зарегистрируйтесь';
  }

  static void update({
    required String name,
    required String email,
    required String password,
  }) {
    final user = session.value;
    if (user == null) return;
    final index = _users.indexOf(user);
    final updated = AppUser(
      name: name.trim(),
      email: email.trim().toLowerCase(),
      password: password,
    );
    if (index >= 0) {
      _users[index] = updated;
    }
    session.value = updated;
    _save();
  }
}
