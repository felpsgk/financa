import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/auth_provider.dart';
import '../controllers/movements_controller.dart';
import '../models/movement.dart';
import '../../../core/navigation_provider.dart';
import '../../../widgets/bottom_nav.dart';
import 'package:intl/intl.dart';

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
                        readOnly: true,
                        decoration: const InputDecoration(labelText: 'Data inicial (dd/mm/yyyy)'),
                        onTap: () => pickDate(startCtrl),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: endCtrl,
                        readOnly: true,
                        decoration: const InputDecoration(labelText: 'Data final (dd/mm/yyyy)'),
                        onTap: () => pickDate(endCtrl),
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
    ref.read(movementsControllerProvider.notifier).setDateRange(startDate: startCtrl.text.isEmpty ? null : toIso(startCtrl.text), endDate: endCtrl.text.isEmpty ? null : toIso(endCtrl.text));
    ref.read(movementsControllerProvider.notifier).load();
  }

  void pickDate(TextEditingController ctrl) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(context: context, initialDate: now, firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (picked != null) {
      ctrl.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  String toIso(String v) {
    final List<String> parts = v.split('/');
    final DateTime dt = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
    return DateFormat('yyyy-MM-dd').format(dt);
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
          title: Text('${m.nomeMovimentacao} \n(Quem? - ${m.contatoNome})'),
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