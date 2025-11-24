import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/auth_provider.dart';
import '../controllers/movements_controller.dart';
import '../data/movements_repository.dart';
import '../models/movement_type.dart';
import '../../../core/input_formatters/money_input_formatter.dart';
import '../models/category.dart';
import '../models/account.dart';
import '../models/contact.dart';
import 'package:intl/intl.dart';
import '../../../core/constants.dart';
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
  final TextEditingController parcelasCtrl = TextEditingController();
  bool isSubmitting = false;
  List<MovementType> types = const [];
  MovementType? selectedType;
  bool isLoadingTypes = true;
  List<Category> categories = const [];
  Category? selectedCategory;
  bool isLoadingCategories = true;
  List<Account> accounts = const [];
  Account? selectedAccount;
  bool isLoadingAccounts = true;
  String? selectedRecurrence;
  List<Contact> contacts = const [];
  Contact? selectedContact;
  bool isLoadingContacts = true;
  @override
  void initState() {
    super.initState();
    ref.read(bottomNavIndexProvider.notifier).state = 2;
    _loadTypes();
    _loadCategories();
    _loadAccounts();
    _loadContacts();
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
                  DropdownButtonFormField<MovementType>(
                    isExpanded: true,
                    hint: const Text('Selecione o tipo'),
                    disabledHint: const Text('Carregando...'),
                    initialValue: selectedType,
                    items: types
                        .map(
                          (t) => DropdownMenuItem<MovementType>(
                            value: t,
                            child: Text(t.nome),
                          ),
                        )
                        .toList(),
                    onChanged: isLoadingTypes ? null : (v) => setState(() => selectedType = v),
                    decoration: const InputDecoration(
                      labelText: 'Tipo de movimentação',
                    ),
                    validator: (v) => v == null ? 'Obrigatório' : null,
                  ),
                  DropdownButtonFormField<Category>(
                    isExpanded: true,
                    hint: const Text('Selecione a categoria'),
                    disabledHint: const Text('Carregando...'),
                    initialValue: selectedCategory,
                    items: categories.map((c) => DropdownMenuItem<Category>(value: c, child: Text(c.nome))).toList(),
                    onChanged: isLoadingCategories ? null : (v) => setState(() => selectedCategory = v),
                    decoration: const InputDecoration(labelText: 'Categoria'),
                    validator: (v) => v == null ? 'Obrigatório' : null,
                  ),
                  DropdownButtonFormField<Account>(
                    isExpanded: true,
                    hint: const Text('Selecione a conta'),
                    disabledHint: const Text('Carregando...'),
                    initialValue: selectedAccount,
                    items: accounts.map((a) => DropdownMenuItem<Account>(value: a, child: Text(a.nome))).toList(),
                    onChanged: isLoadingAccounts ? null : (v) => setState(() => selectedAccount = v),
                    decoration: const InputDecoration(labelText: 'Conta bancária'),
                    validator: (v) => v == null ? 'Obrigatório' : null,
                  ),
                  DropdownButtonFormField<Contact>(
                    isExpanded: true,
                    hint: const Text('Selecione quem pagou'),
                    disabledHint: const Text('Carregando...'),
                    initialValue: selectedContact,
                    items: contacts.map((c) => DropdownMenuItem<Contact>(value: c, child: Text(c.nome))).toList(),
                    onChanged: isLoadingContacts ? null : (v) => setState(() => selectedContact = v),
                    decoration: const InputDecoration(labelText: 'Contato (quem pagou)'),
                  ),
                  TextFormField(
                    controller: nomeCtrl,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Obrigatório' : null,
                  ),
                  TextFormField(
                    controller: dscCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Descrição (opcional)',
                    ),
                  ),
                  TextFormField(
                    controller: dtCtrl,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Data movimentação (dd/mm/yyyy)',
                    ),
                    validator: (v) => _validateDate(v, required: true),
                    onTap: () => _pickDate(context, dtCtrl),
                  ),
                  TextFormField(
                    controller: dtVencCtrl,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Data vencimento/pagamento (dd/mm/yyyy)',
                    ),
                    validator: (v) => _validateDate(v, required: false),
                    onTap: () => _pickDate(context, dtVencCtrl),
                  ),
                  TextFormField(
                    controller: parcelasCtrl,
                    decoration: const InputDecoration(labelText: 'Parcelamento (qtd parcelas)'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    hint: const Text('Selecione a recorrência'),
                    value: selectedRecurrence,
                    items: const [
                      DropdownMenuItem(value: 'Unica', child: Text('Única')),
                      DropdownMenuItem(value: 'Semanal', child: Text('Semanal')),
                      DropdownMenuItem(value: 'Quinzenal', child: Text('Quinzenal')),
                      DropdownMenuItem(value: 'Mensal', child: Text('Mensal')),
                      DropdownMenuItem(value: 'Anual', child: Text('Anual')),
                    ],
                    onChanged: (v) => setState(() => selectedRecurrence = v),
                    decoration: const InputDecoration(labelText: 'Recorrência'),
                  ),
                  Focus(
                    onFocusChange: (hasFocus) {
                      if (!hasFocus) {
                        String txt = valorCtrl.text;
                        // Se o usuário deixou um valor incompleto, não formate
                        if (txt.endsWith('.') || txt.isEmpty) return;
                        final double? val = double.tryParse(txt);
                        if (val != null) {
                          valorCtrl.text = val.toStringAsFixed(2);
                          valorCtrl.selection = TextSelection.collapsed(
                            offset: valorCtrl.text.length,
                          );
                        }
                      }
                    },
                    child: TextFormField(
                      controller: valorCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Valor',
                        prefixText: 'R\$ ',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: const [MoneyInputFormatter()],
                      validator: _validateMoney,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: isSubmitting || idpessoa == null ? null : submit,
                    child: isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Salvar'),
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
      final String isoDate = _toIsoDate(dtCtrl.text);
      final String? isoDue = dtVencCtrl.text.isEmpty
          ? null
          : _toIsoDate(dtVencCtrl.text);
      valorCtrl.text = MoneyInputFormatter.formatFinal(valorCtrl.text);
      double val = double.tryParse(valorCtrl.text) ?? 0;
      if (selectedType != null && selectedType!.isEntrada == false && val > 0) {
        val = -val;
      }
      final int? idCategoria = selectedCategory?.id;
      final bool isEntrada = selectedType?.isEntrada == true;
      final int? idLocalOrigem = isEntrada ? null : selectedAccount?.id;
      final int? idLocalDestino = isEntrada ? selectedAccount?.id : null;
      final int? idContato = selectedContact?.id;
      final String recurrenceType = selectedRecurrence ?? 'Unica';
      final int? qtdParcelas = parcelasCtrl.text.isEmpty ? null : int.tryParse(parcelasCtrl.text);
      final bool useParcelamento = (qtdParcelas != null && qtdParcelas > 1) || (recurrenceType != 'Unica');
      if (useParcelamento) {
        await repo.createParcelamento(
          idpessoa: idpessoa,
          tipo: isEntrada ? 'entrada' : 'saida',
          nome: nomeCtrl.text,
          descricao: dscCtrl.text.isEmpty ? null : dscCtrl.text,
          qtdParcelas: qtdParcelas ?? 1,
          recurrenceType: recurrenceType,
          valorParcela: val.abs(),
          dtInicio: isoDate,
          idLocalOrigem: idLocalOrigem,
          idLocalDestino: idLocalDestino,
          idContato: idContato,
          idTipoMovimentacao: selectedType?.id,
          idCategoria: idCategoria,
        );
      } else {
        await repo.create(
          idpessoa: idpessoa,
          tipoMovimentacao: selectedType?.nome ?? tipoCtrl.text,
          nomeMovimentacao: nomeCtrl.text,
          dscMovimentacao: dscCtrl.text.isEmpty ? null : dscCtrl.text,
          dtMovimentacao: isoDate,
          dtVencimento: isoDue,
          valor: isEntrada ? val.abs() : -val.abs(),
          idTipoMovimentacao: selectedType?.id,
          idCategoria: idCategoria,
          idLocalOrigem: idLocalOrigem,
          idLocalDestino: idLocalDestino,
          idContato: idContato,
          isPago: 0,
          dtPagamento: isoDue,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao salvar')));
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  String? _validateDate(String? v, {required bool required}) {
    if ((v == null || v.isEmpty) && required) return 'Obrigatório';
    if (v == null || v.isEmpty) return null;
    final RegExp re = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!re.hasMatch(v)) return 'Formato dd/mm/yyyy';
    final String iso = _toIsoDate(v);
    final DateTime? dt = DateTime.tryParse(iso);
    if (dt == null) return 'Data inválida';
    return null;
  }

  String _toIsoDate(String v) {
    final List<String> parts = v.split('/');
    final int d = int.parse(parts[0]);
    final int m = int.parse(parts[1]);
    final int y = int.parse(parts[2]);
    final DateTime dt = DateTime(y, m, d);
    return DateFormat('yyyy-MM-dd').format(dt);
  }

  Future<void> _pickDate(
    BuildContext context,
    TextEditingController ctrl,
  ) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      ctrl.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  String? _validateMoney(String? v) {
    if (v == null || v.isEmpty) return 'Obrigatório';
    final double? val = double.tryParse(v);
    if (val == null) return 'Valor inválido';
    if (val < AppConstants.moneyMinValue) {
      return 'Valor mínimo ${AppConstants.moneyMinValue.toStringAsFixed(2)}';
    }
    if (val > AppConstants.moneyMaxValue) {
      return 'Valor máximo ${AppConstants.moneyMaxValue.toStringAsFixed(2)}';
    }
    return null;
  }

  Future<void> _loadTypes() async {
    try {
      final MovementsRepository repo = ref.read(movementsRepositoryProvider);
      final List<MovementType> list = await repo.getTypes();
      setState(() {
        types = list;
        isLoadingTypes = false;
      });
    } catch (_) {
      setState(() => isLoadingTypes = false);
    }
  }

  Future<void> _loadCategories() async {
    try {
      final MovementsRepository repo = ref.read(movementsRepositoryProvider);
      final List<Category> list = await repo.getCategories();
      setState(() {
        categories = list;
        isLoadingCategories = false;
      });
    } catch (_) {
      setState(() => isLoadingCategories = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Falha ao carregar categorias')));
      }
    }
  }

  Future<void> _loadAccounts() async {
    try {
      final MovementsRepository repo = ref.read(movementsRepositoryProvider);
      final List<Account> list = await repo.getAccounts();
      setState(() {
        accounts = list;
        isLoadingAccounts = false;
      });
    } catch (_) {
      setState(() => isLoadingAccounts = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Falha ao carregar contas')));
      }
    }
  }

  Future<void> _loadContacts() async {
    try {
      final MovementsRepository repo = ref.read(movementsRepositoryProvider);
      final List<Contact> list = await repo.getContacts();
      setState(() {
        contacts = list;
        isLoadingContacts = false;
      });
    } catch (_) {
      setState(() => isLoadingContacts = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Falha ao carregar contatos')));
      }
    }
  }
}
