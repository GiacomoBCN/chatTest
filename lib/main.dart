import 'package:flutter/material.dart';
import 'app_scope.dart';
import 'screens/demo_screen.dart';
import 'theme/falak_theme.dart';

void main() {
  runApp(const FalakApp());
}

class FalakApp extends StatefulWidget {
  const FalakApp({super.key});

  @override
  State<FalakApp> createState() => _FalakAppState();
}

class _FalakAppState extends State<FalakApp> {
  bool _isArabic = false;
  bool? _isDark; // null = follow the system until the user chooses

  @override
  Widget build(BuildContext context) {
    final systemDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final isDark = _isDark ?? systemDark;

    return AppScope(
      isArabic: _isArabic,
      isDark: isDark,
      setArabic: (v) => setState(() => _isArabic = v),
      toggleTheme: () => setState(() => _isDark = !isDark),
      child: MaterialApp(
        title: 'Falak · AI assistant concept',
        debugShowCheckedModeBanner: false,
        theme: buildFalakTheme(isDark ? Brightness.dark : Brightness.light),
        builder: (context, child) => Directionality(
          textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        ),
        home: const DemoScreen(),
      ),
    );
  }
}
