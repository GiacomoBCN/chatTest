import 'package:flutter/material.dart';

/// App-wide settings: language and theme. Rebuilds dependants on change.
class AppScope extends InheritedWidget {
  final bool isArabic;
  final bool isDark;
  final ValueChanged<bool> setArabic;
  final VoidCallback toggleTheme;

  const AppScope({
    super.key,
    required this.isArabic,
    required this.isDark,
    required this.setArabic,
    required this.toggleTheme,
    required super.child,
  });

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'No AppScope found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      oldWidget.isArabic != isArabic || oldWidget.isDark != isDark;
}
