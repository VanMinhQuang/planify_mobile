import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({
    required this.themeMode,
    required this.onChanged,
    this.tooltip,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onChanged;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip ?? _tooltip,
      onPressed: () => onChanged(_nextMode),
      icon: Icon(_icon),
    );
  }

  ThemeMode get _nextMode =>
      themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

  IconData get _icon =>
      themeMode == ThemeMode.light ? LucideIcons.sun : LucideIcons.moon;

  String get _tooltip =>
      themeMode == ThemeMode.light ? 'Use dark theme' : 'Use light theme';
}
