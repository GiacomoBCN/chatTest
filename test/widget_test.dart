import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_test/main.dart';

void main() {
  testWidgets('Demo starts with the AI disclosure and the examples', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    await tester.pumpWidget(const FalakApp());
    expect(find.textContaining("You're chatting with an AI assistant."), findsOneWidget);
    expect(find.text('Balance'), findsOneWidget);
    expect(find.text('Client to contact'), findsOneWidget);
  });
}
