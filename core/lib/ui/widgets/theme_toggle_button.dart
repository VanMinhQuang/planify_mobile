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

  ThemeMode get _nextMode {
    return switch (themeMode) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
  }

  IconData get _icon {
    return switch (themeMode) {
      ThemeMode.system => LucideIcons.monitor,
      ThemeMode.light => LucideIcons.sun,
      ThemeMode.dark => LucideIcons.moon,
    };
  }

  String get _tooltip {
    return switch (themeMode) {
      ThemeMode.system => 'Use light theme',
      ThemeMode.light => 'Use dark theme',
      ThemeMode.dark => 'Use system theme',
    };
  }
}
