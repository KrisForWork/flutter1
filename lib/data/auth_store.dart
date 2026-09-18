import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUser {
  AppUser({
    required this.name,
    required this.email,
    required this.password,
    this.photoBase64,
  });

  String name;
  String email;
  String password;
  String? photoBase64;

  Uint8List? get photoBytes {
    final data = photoBase64;
    if (data == null || data.isEmpty) return null;
    try {
      return base64Decode(data);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'photoBase64': photoBase64,
  };

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      photoBase64: json['photoBase64'] as String?,
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
    await prefs.remove(_sessionKey);
    session.value = null;
    loggedIn.value = false;
  }

  static void _setUser(AppUser? user, {bool save = false}) {
    session.value = user;
    loggedIn.value = user != null;
    if (save) {
      _save();
    }
  }

  static Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _usersKey,
      jsonEncode(_users.map((user) => user.toJson()).toList()),
    );
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
    _setUser(user, save: true);
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

  static void logout() {
    _setUser(null);
  }

  static void update({
    required String name,
    required String email,
    required String password,
    String? photoBase64,
  }) {
    final user = session.value;
    if (user == null) return;
    final index = _users.indexOf(user);
    final updated = AppUser(
      name: name.trim(),
      email: email.trim().toLowerCase(),
      password: password,
      photoBase64: photoBase64 ?? user.photoBase64,
    );
    if (index >= 0) {
      _users[index] = updated;
    }
    session.value = updated;
    _save();
  }

  static void updatePhoto(String photoBase64) {
    final user = session.value;
    if (user == null) return;
    update(
      name: user.name,
      email: user.email,
      password: user.password,
      photoBase64: photoBase64,
    );
  }
}
