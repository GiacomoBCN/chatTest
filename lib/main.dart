import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(const CommercialBankApp());
}

class CommercialBankApp extends StatelessWidget {
  const CommercialBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Commercial Bank AI Assistant',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const ChatScreen(),
    );
  }
}
