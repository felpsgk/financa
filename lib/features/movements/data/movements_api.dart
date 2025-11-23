import 'dart:convert';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import '../../../core/constants.dart';
import '../models/movement.dart';
import '../models/movement_type.dart';
import '../models/category.dart';
import '../models/account.dart';

class MovementsApi {
  const MovementsApi();

  Uri buildGetMovementsUri(int idpessoa, {String? startDate, String? endDate}) {
    final String base = AppConstants.apiBaseUrl;
    final String path = AppConstants.getMovementsPath;
    final Map<String, String> params = {
      'idpessoa': '$idpessoa',
      if (startDate != null) 'start': startDate,
      if (endDate != null) 'end': endDate,
    };
    return Uri.parse('$base/$path').replace(queryParameters: params);
  }

  Uri buildCreateMovementUri() {
    final String base = AppConstants.apiBaseUrl;
    final String path = AppConstants.createMovementPath;
    return Uri.parse('$base/$path');
  }

  Uri buildGetTypesUri() {
    final String base = AppConstants.apiBaseUrl;
    final String path = AppConstants.getTypesPath;
    return Uri.parse('$base/$path');
  }

  Uri buildGetCategoriesUri() {
    final String base = AppConstants.apiBaseUrl;
    final String path = AppConstants.getCategoriesPath;
    return Uri.parse('$base/$path');
  }

  Uri buildGetAccountsUri() {
    final String base = AppConstants.apiBaseUrl;
    final String path = AppConstants.getAccountsPath;
    return Uri.parse('$base/$path');
  }

  Future<List<Movement>> fetchMovements({required int idpessoa, String? startDate, String? endDate}) async {
    final Uri uri = buildGetMovementsUri(idpessoa, startDate: startDate, endDate: endDate);
    final http.Response res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Failed to load movements');
    }
    final List<dynamic> data = json.decode(res.body) as List<dynamic>;
    return data.map((e) => Movement.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> createMovement({
    required int idpessoa,
    required String tipoMovimentacao,
    required String nomeMovimentacao,
    String? dscMovimentacao,
    required String dtMovimentacao,
    String? dtVencimento,
    required double valor,
    int? idTipoMovimentacao,
  }) async {
    final Uri uri = buildCreateMovementUri();
    final Map<String, dynamic> body = {
      'idpessoa': idpessoa,
      'tipo_movimentacao': tipoMovimentacao,
      'nome_movimentacao': nomeMovimentacao,
      'dsc_movimentacao': dscMovimentacao,
      'dt_movimentacao': dtMovimentacao,
      'dt_vencimento': dtVencimento,
      'valor': valor,
      if (idTipoMovimentacao != null) 'id_tipo_movimentacao': idTipoMovimentacao,
    };
    final http.Response res = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: json.encode(body));
    if (res.statusCode != 201) {
      throw Exception('Failed to create movement');
    }
  }

  Future<List<MovementType>> fetchTypes() async {
    final Uri uri = buildGetTypesUri();
    dev.log('fetchTypes: GET $uri');
    final http.Response res = await http.get(uri);
    dev.log('fetchTypes: status ${res.statusCode}');
    dev.log('fetchTypes: body len ${res.body.length}');
    if (res.statusCode != 200) {
      throw Exception('Failed to load movement types (status: ${res.statusCode})');
    }
    dynamic decoded;
    try {
      decoded = json.decode(res.body);
    } catch (e) {
      dev.log('fetchTypes: JSON decode error', error: e);
      throw Exception('Invalid JSON from types endpoint');
    }
    if (decoded is! List) {
      dev.log('fetchTypes: decoded is not a List, type=${decoded.runtimeType}');
      throw Exception('Types response is not a list');
    }
    final List<dynamic> data = decoded;
    dev.log('fetchTypes: items count ${data.length}');
    final List<MovementType> result = <MovementType>[];
    for (final dynamic item in data) {
      if (item is Map<String, dynamic>) {
        try {
          final MovementType t = MovementType.fromJson(item);
          result.add(t);
        } catch (e) {
          dev.log('fetchTypes: item parse failed', error: e, name: 'MovementType');
        }
      } else {
        dev.log('fetchTypes: skipping non-Map item type=${item.runtimeType}');
      }
    }
    dev.log('fetchTypes: mapped count ${result.length}');
    return result;
  }

  Future<List<Category>> fetchCategories() async {
    final Uri uri = buildGetCategoriesUri();
    final http.Response res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Failed to load categories');
    }
    final List<dynamic> data = json.decode(res.body) as List<dynamic>;
    return data.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Account>> fetchAccounts() async {
    final Uri uri = buildGetAccountsUri();
    final http.Response res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Failed to load accounts');
    }
    final List<dynamic> data = json.decode(res.body) as List<dynamic>;
    return data.map((e) => Account.fromJson(e as Map<String, dynamic>)).toList();
  }
}