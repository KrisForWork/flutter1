import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/theme_cubit.dart';

class ThemeModeButton extends StatelessWidget {
  const ThemeModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        return Switch(
          value: mode == ThemeMode.dark,
          onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
        );
      },
    );
  }
}
