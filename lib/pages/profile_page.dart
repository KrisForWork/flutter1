import 'package:flutter/material.dart';

import '../data/auth_store.dart';
import '../widgets/text_field.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProfilePage(),
  ));
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      ClipOval(
                        child: Image.network(
                          'https://images.unsplash.com/photo-1558788353-f76d92427f16?w=400',
                          width: 128,
                          height: 128,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 128,
                            height: 128,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.person, size: 64),
                          ),
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
                  ),
                  child: const Text('Сохранить'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
