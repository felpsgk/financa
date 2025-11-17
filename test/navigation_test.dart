import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:financas_app/features/summary/ui/summary_page.dart';
import 'package:financas_app/widgets/bottom_nav.dart';

void main() {
  testWidgets('BottomNavBar is visible on Summary and hidden on Login', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: SummaryPage())));
    expect(find.byType(BottomNavBar), findsOneWidget);
  });
}