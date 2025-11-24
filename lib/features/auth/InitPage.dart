import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'session_storage.dart';
import 'auth_provider.dart';

class InitPage extends ConsumerStatefulWidget {
  const InitPage({super.key});

  @override
  ConsumerState<InitPage> createState() => _InitPageState();
}

class _InitPageState extends ConsumerState<InitPage> {
  final SessionStorage storage = const SessionStorage();

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final idStr = await storage.readString(key: 'USER_ID');
    final expStr = await storage.readString(key: 'SESSION_EXP');

    if (idStr == null || expStr == null) {
      _go('/login');
      return;
    }

    final int? id = int.tryParse(idStr);
    final int? exp = int.tryParse(expStr);

    if (id == null || exp == null) {
      _go('/login');
      return;
    }

    final now = DateTime.now().millisecondsSinceEpoch;

    if (now >= exp) {
      // Sessão expirada
      await storage.delete(key: 'USER_ID');
      await storage.delete(key: 'SESSION_EXP');
      _go('/login');
      return;
    }

    // Tudo OK → restaura provider
    ref.read(userIdProvider.notifier).state = id;

    _go('/summary');
  }

  void _go(String route) {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
