import 'package:flutter/material.dart';

class LanguageProvider extends InheritedWidget {
  final bool isArabic;
  final VoidCallback toggleLanguage;

  const LanguageProvider({
    super.key,
    required this.isArabic,
    required this.toggleLanguage,
    required super.child,
  });

  static LanguageProvider of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<LanguageProvider>();
    assert(provider != null, 'No LanguageProvider found in context');
    return provider!;
  }

  @override
  bool updateShouldNotify(LanguageProvider old) => old.isArabic != isArabic;
}
