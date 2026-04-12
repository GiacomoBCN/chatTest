import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_theme.dart';
import 'screens/chat_screen.dart';
import 'language_provider.dart';

void main() {
  runApp(const CommercialBankApp());
}

class CommercialBankApp extends StatefulWidget {
  const CommercialBankApp({super.key});

  @override
  State<CommercialBankApp> createState() => _CommercialBankAppState();
}

class _CommercialBankAppState extends State<CommercialBankApp> {
  bool _isArabic = false;

  void _toggleLanguage() {
    setState(() => _isArabic = !_isArabic);
  }

  ThemeData get _theme {
    if (!_isArabic) return AppTheme.theme;
    return AppTheme.theme.copyWith(
      textTheme: GoogleFonts.notoSansArabicTextTheme(AppTheme.theme.textTheme),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LanguageProvider(
      isArabic: _isArabic,
      toggleLanguage: _toggleLanguage,
      child: MaterialApp(
        title: 'Commercial Bank AI Assistant',
        debugShowCheckedModeBanner: false,
        theme: _theme,
        // Wrap all content in Directionality so every widget mirrors correctly.
        builder: (context, child) => Directionality(
          textDirection:
              _isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        ),
        home: const ChatScreen(),
      ),
    );
  }
}
