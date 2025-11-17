import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  void navigateAfterLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/summary');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int? selected = ref.watch(userIdProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Selecione o usuário'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                children: [
                  ChoiceChip(
                    label: const Text('Usuário 1'),
                    selected: selected == 1,
                    onSelected: (_) => ref.read(userIdProvider.notifier).state = 1,
                  ),
                  ChoiceChip(
                    label: const Text('Usuário 2'),
                    selected: selected == 2,
                    onSelected: (_) => ref.read(userIdProvider.notifier).state = 2,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: selected == null ? null : () => navigateAfterLogin(context),
                child: const Text('Entrar'),
              ),
              const SizedBox(height: 24),
              Text(
                'Após login você verá resumo, lista e poderá criar movimentações.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}