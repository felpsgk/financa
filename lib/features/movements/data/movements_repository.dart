import '../models/movement.dart';
import 'movements_api.dart';
import '../models/movement_type.dart';
import '../models/category.dart';
import '../models/account.dart';
import '../models/contact.dart';

class MovementsRepository {
  final MovementsApi api;

  const MovementsRepository({required this.api});

  Future<List<Movement>> getMovements({required int idpessoa, String? startDate, String? endDate}) {
    return api.fetchMovements(idpessoa: idpessoa, startDate: startDate, endDate: endDate);
  }

  Future<void> create({
    required int idpessoa,
    required String tipoMovimentacao,
    required String nomeMovimentacao,
    String? dscMovimentacao,
    required String dtMovimentacao,
    String? dtVencimento,
    required double valor,
    int? idTipoMovimentacao,
    int? idCategoria,
    int? idLocalOrigem,
    int? idLocalDestino,
    int? idContato,
    int? isPago,
    String? dtPagamento,
  }) {
    return api.createMovement(
      idpessoa: idpessoa,
      tipoMovimentacao: tipoMovimentacao,
      nomeMovimentacao: nomeMovimentacao,
      dscMovimentacao: dscMovimentacao,
      dtMovimentacao: dtMovimentacao,
      dtVencimento: dtVencimento,
      valor: valor,
      idTipoMovimentacao: idTipoMovimentacao,
      idCategoria: idCategoria,
      idLocalOrigem: idLocalOrigem,
      idLocalDestino: idLocalDestino,
      idContato: idContato,
      isPago: isPago,
      dtPagamento: dtPagamento,
    );
  }

  Future<List<MovementType>> getTypes() {
    return api.fetchTypes();
  }

  Future<List<Category>> getCategories() {
    return api.fetchCategories();
  }

  Future<List<Account>> getAccounts() {
    return api.fetchAccounts();
  }

  Future<List<Contact>> getContacts() {
    return api.fetchContacts();
  }

  Future<Map<String, dynamic>> createParcelamento({
    required int idpessoa,
    required String tipo,
    required String nome,
    String? descricao,
    int? qtdParcelas,
    required String recurrenceType,
    required double valorParcela,
    required String dtInicio,
    int? idLocalOrigem,
    int? idLocalDestino,
    int? idContato,
    int? idTipoMovimentacao,
    int? idCategoria,
  }) {
    return api.createParcelamento(
      idpessoa: idpessoa,
      tipo: tipo,
      nome: nome,
      descricao: descricao,
      qtdParcelas: qtdParcelas,
      recurrenceType: recurrenceType,
      valorParcela: valorParcela,
      dtInicio: dtInicio,
      idLocalOrigem: idLocalOrigem,
      idLocalDestino: idLocalDestino,
      idContato: idContato,
      idTipoMovimentacao: idTipoMovimentacao,
      idCategoria: idCategoria,
    );
  }
}