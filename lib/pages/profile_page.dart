import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/auth_store.dart';
import '../routes.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/text_field.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProfilePage(),
  ));
}

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.size, this.user});

  final double size;
  final AppUser? user;

  @override
  Widget build(BuildContext context) {
    final bytes = user?.photoBytes;
    if (bytes != null) {
      return ClipOval(
        child: Image.memory(
          bytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Colors.grey.shade300,
      child: Icon(Icons.person, size: size * 0.5, color: Colors.black54),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(
    text: AuthStore.current?.name ?? 'Иванов Иван Иванович',
  );
  late final _emailController = TextEditingController(
    text: AuthStore.current?.email ?? 'test123@mail.ru',
  );
  late final _passwordController = TextEditingController(
    text: AuthStore.current?.password ?? '',
  );
  late final _confirmController = TextEditingController(
    text: AuthStore.current?.password ?? '',
  );
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    AuthStore.update(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Профиль сохранён')),
    );
  }

  Future<void> _changePhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Галерея'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Камера'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );
    if (source == null) return;
    try {
      final file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      AuthStore.updatePhoto(base64Encode(bytes));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось выбрать фото')),
      );
    }
  }

  void _logout() {
    AuthStore.logout();
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Профиль',
          style: TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 26,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            }
          },
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _changePhoto,
                  child: SizedBox(
                    width: 140,
                    height: 140,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        ValueListenableBuilder<AppUser?>(
                          valueListenable: AuthStore.session,
                          builder: (_, user, _) => UserAvatar(
                            size: 128,
                            user: user,
                          ),
                        ),
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.black,
                          child: Icon(
                            Icons.photo_camera,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _nameController,
                  type: FieldType.name,
                  hint: 'ФИО',
                  focusNode: _nameFocus,
                  nextFocus: _emailFocus,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  type: FieldType.email,
                  hint: 'Email',
                  focusNode: _emailFocus,
                  nextFocus: _passwordFocus,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  type: FieldType.password,
                  hint: 'Пароль',
                  focusNode: _passwordFocus,
                  nextFocus: _confirmFocus,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _confirmController,
                  type: FieldType.confirmPassword,
                  hint: 'Повторите пароль',
                  focusNode: _confirmFocus,
                  passwordController: _passwordController,
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'Pacifico',
                      fontSize: 18,
                    ),
                  ),
                  child: const Text('Сохранить'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _logout,
                  child: const Text(
                    'Выйти',
                    style: TextStyle(
                      fontFamily: 'Pacifico',
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
