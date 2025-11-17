import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/login_page.dart';
import '../features/summary/ui/summary_page.dart';
import '../features/movements/ui/movements_list_page.dart';
import '../features/movements/ui/create_movement_page.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Finanças',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo), useMaterial3: true),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/summary': (_) => const SummaryPage(),
        '/movements': (_) => const MovementsListPage(),
        '/create': (_) => const CreateMovementPage(),
      },
    );
  }
}