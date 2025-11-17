import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/auth_provider.dart';
import '../../movements/controllers/movements_controller.dart';
import '../../../core/navigation_provider.dart';
import '../../../widgets/bottom_nav.dart';

class SummaryPage extends ConsumerWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int? userId = ref.watch(userIdProvider);
    final MovementsState state = ref.watch(movementsControllerProvider);
    ref.read(bottomNavIndexProvider.notifier).state = 0;
    final double income = state.movements.where((m) => m.valor >= 0).fold(0.0, (p, m) => p + m.valor);
    final double expense = state.movements.where((m) => m.valor < 0).fold(0.0, (p, m) => p + m.valor.abs());
    final double balance = income - expense;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SummaryCard(title: 'Ganhos', value: income, color: Colors.green),
                    const SizedBox(width: 16),
                    _SummaryCard(title: 'Gastos', value: expense, color: Colors.red),
                    const SizedBox(width: 16),
                    _SummaryCard(title: 'Saldo', value: balance, color: Colors.indigo),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(onPressed: () => _load(ref, userId), child: const Text('Atualizar')),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  void _load(WidgetRef ref, int? userId) {
    print('userId: $userId');
    if (userId == null) return;
    ref.read(movementsControllerProvider.notifier).load();
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double value;
  final Color color;
  const _SummaryCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(value.toStringAsFixed(2), style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}