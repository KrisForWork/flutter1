import 'package:flutter/material.dart';

enum FieldType { name, email, password, confirmPassword }

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.type,
    required this.hint,
    this.focusNode,
    this.nextFocus,
    this.passwordController,
  });

  final TextEditingController controller;
  final FieldType type;
  final String hint;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextEditingController? passwordController;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  bool get _isPassword =>
      widget.type == FieldType.password ||
      widget.type == FieldType.confirmPassword;

  IconData get _prefixIcon => switch (widget.type) {
    FieldType.name => Icons.person_outline,
    FieldType.email => Icons.mail_outline,
    FieldType.password || FieldType.confirmPassword => Icons.shield_outlined,
  };

  String? _validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Поле не может быть пустым';
    }

    switch (widget.type) {
      case FieldType.name:
        if (!RegExp(r'^[a-zA-Zа-яА-ЯёЁ ]+$').hasMatch(value.trim())) {
          return 'Только буквы и пробелы';
        }
      case FieldType.email:
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value.trim())) {
          return 'Некорректный email';
        }
      case FieldType.password:
      case FieldType.confirmPassword:
        if (value.length < 6) {
          return 'Не менее 6 символов';
        }
        if (!RegExp(r'[A-Za-zА-Яа-яЁё]').hasMatch(value)) {
          return 'Должен содержать буквы';
        }
        if (!RegExp(r'[0-9]').hasMatch(value)) {
          return 'Должен содержать цифры';
        }
        if (!RegExp(r'[+\-_]').hasMatch(value)) {
          return 'Должен содержать +, _ или -';
        }
        if (widget.type == FieldType.confirmPassword &&
            widget.passwordController != null &&
            value != widget.passwordController!.text) {
          return 'Пароли не совпадают';
        }
    }
    return null;
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: _isPassword && _obscure,
      keyboardType: widget.type == FieldType.email
          ? TextInputType.emailAddress
          : TextInputType.text,
      textInputAction: widget.nextFocus != null
          ? TextInputAction.next
          : TextInputAction.done,
      validator: _validate,
      onFieldSubmitted: (_) {
        if (widget.nextFocus != null) {
          widget.nextFocus!.requestFocus();
        } else {
          FocusScope.of(context).unfocus();
        }
      },
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: Icon(_prefixIcon, color: Colors.black54),
        suffixIcon: _isPassword
            ? IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.black54,
                ),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(),
      ),
    );
  }
}
