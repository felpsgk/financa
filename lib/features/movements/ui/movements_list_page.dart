import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/auth_provider.dart';
import '../controllers/movements_controller.dart';
import '../models/movement.dart';
import '../../../core/navigation_provider.dart';
import '../../../widgets/bottom_nav.dart';

class MovementsListPage extends ConsumerStatefulWidget {
  const MovementsListPage({super.key});

  @override
  ConsumerState<MovementsListPage> createState() => _MovementsListPageState();
}

class _MovementsListPageState extends ConsumerState<MovementsListPage> {
  final TextEditingController startCtrl = TextEditingController();
  final TextEditingController endCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(bottomNavIndexProvider.notifier).state = 1;
    Future.microtask(() => ref.read(movementsControllerProvider.notifier).load());
  }

  @override
  void dispose() {
    startCtrl.dispose();
    endCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int? userId = ref.watch(userIdProvider);
    final MovementsState state = ref.watch(movementsControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movimentações'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: startCtrl,
                        decoration: const InputDecoration(labelText: 'Data inicial (YYYY-MM-DD)'),
                        onSubmitted: (_) => applyFilter(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: endCtrl,
                        decoration: const InputDecoration(labelText: 'Data final (YYYY-MM-DD)'),
                        onSubmitted: (_) => applyFilter(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(onPressed: applyFilter, child: const Text('Filtrar')),
                  ],
                ),
              ),
              if (userId == null) const Padding(padding: EdgeInsets.all(24), child: Text('Selecione o usuário no login.')),
              if (state.isLoading) const Expanded(child: Center(child: CircularProgressIndicator())),
              if (!state.isLoading) Expanded(child: _MovementsTable(items: state.movements)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  void applyFilter() {
    ref.read(movementsControllerProvider.notifier).setDateRange(startDate: startCtrl.text.isEmpty ? null : startCtrl.text, endDate: endCtrl.text.isEmpty ? null : endCtrl.text);
    ref.read(movementsControllerProvider.notifier).load();
  }
}

class _MovementsTable extends StatelessWidget {
  final List<Movement> items;
  const _MovementsTable({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final Movement m = items[i];
        final bool isIncome = m.valor >= 0;
        return ListTile(
          title: Text(m.nomeMovimentacao),
          subtitle: Text('${m.tipoMovimentacao} • ${m.dtMovimentacao}${m.dtVencimento != null ? ' • ${m.dtVencimento}' : ''}'),
          trailing: Text(
            m.valor.toStringAsFixed(2),
            style: TextStyle(color: isIncome ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}