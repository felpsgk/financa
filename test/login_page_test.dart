import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
// import 'package:financas_app/features/auth/login_page.dart';
import 'package:financas_app/features/auth/InitPage.dart';

void main() {
  testWidgets('Shows Google Sign-In button', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: InitPage())));
    expect(find.text('Entrar com Google'), findsOneWidget);
  });
}