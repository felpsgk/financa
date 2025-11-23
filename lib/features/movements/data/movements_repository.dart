import '../models/movement.dart';
import 'movements_api.dart';
import '../models/movement_type.dart';
import '../models/category.dart';
import '../models/account.dart';

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
}