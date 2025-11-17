import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/auth_provider.dart';
import '../controllers/movements_controller.dart';
import '../data/movements_repository.dart';
import '../../../core/navigation_provider.dart';
import '../../../widgets/bottom_nav.dart';

class CreateMovementPage extends ConsumerStatefulWidget {
  const CreateMovementPage({super.key});

  @override
  ConsumerState<CreateMovementPage> createState() => _CreateMovementPageState();
}

class _CreateMovementPageState extends ConsumerState<CreateMovementPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController tipoCtrl = TextEditingController();
  final TextEditingController nomeCtrl = TextEditingController();
  final TextEditingController dscCtrl = TextEditingController();
  final TextEditingController dtCtrl = TextEditingController();
  final TextEditingController dtVencCtrl = TextEditingController();
  final TextEditingController valorCtrl = TextEditingController();
  bool isSubmitting = false;
  @override
  void initState() {
    super.initState();
    ref.read(bottomNavIndexProvider.notifier).state = 2;
  }

  @override
  void dispose() {
    tipoCtrl.dispose();
    nomeCtrl.dispose();
    dscCtrl.dispose();
    dtCtrl.dispose();
    dtVencCtrl.dispose();
    valorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int? idpessoa = ref.watch(userIdProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Movimentação')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(controller: tipoCtrl, decoration: const InputDecoration(labelText: 'Tipo (ex: salário, aluguel)'), validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null),
                  TextFormField(controller: nomeCtrl, decoration: const InputDecoration(labelText: 'Nome'), validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null),
                  TextFormField(controller: dscCtrl, decoration: const InputDecoration(labelText: 'Descrição (opcional)')),
                  TextFormField(controller: dtCtrl, decoration: const InputDecoration(labelText: 'Data movimentação YYYY-MM-DD'), validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null),
                  TextFormField(controller: dtVencCtrl, decoration: const InputDecoration(labelText: 'Data vencimento/pagamento YYYY-MM-DD (opcional)')),
                  TextFormField(controller: valorCtrl, decoration: const InputDecoration(labelText: 'Valor'), keyboardType: TextInputType.number, validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: isSubmitting || idpessoa == null ? null : submit,
                    child: isSubmitting ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Salvar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => isSubmitting = true);
    try {
      final int idpessoa = ref.read(userIdProvider)!;
      final MovementsRepository repo = ref.read(movementsRepositoryProvider);
      await repo.create(
        idpessoa: idpessoa,
        tipoMovimentacao: tipoCtrl.text,
        nomeMovimentacao: nomeCtrl.text,
        dscMovimentacao: dscCtrl.text.isEmpty ? null : dscCtrl.text,
        dtMovimentacao: dtCtrl.text,
        dtVencimento: dtVencCtrl.text.isEmpty ? null : dtVencCtrl.text,
        valor: double.tryParse(valorCtrl.text.replaceAll(',', '.')) ?? 0,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao salvar')));
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }
}