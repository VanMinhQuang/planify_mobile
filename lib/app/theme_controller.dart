import 'package:flutter/material.dart';

class PlanifyThemeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode value) {
    if (_themeMode == value) {
      return;
    }
    _themeMode = value;
    notifyListeners();
  }
}

class PlanifyThemeScope extends InheritedNotifier<PlanifyThemeController> {
  const PlanifyThemeScope({
    required PlanifyThemeController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static PlanifyThemeController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<PlanifyThemeScope>();
    assert(scope != null, 'PlanifyThemeScope not found in context');
    return scope!.notifier!;
  }
}
