import 'dart:convert';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import '../../../core/constants.dart';
import '../models/movement.dart';
import '../models/movement_type.dart';
import '../models/category.dart';
import '../models/account.dart';
import '../models/contact.dart';

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

  Uri buildGetContactsUri() {
    final String base = AppConstants.apiBaseUrl;
    final String path = AppConstants.getContactsPath;
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
    int? idCategoria,
    int? idLocalOrigem,
    int? idLocalDestino,
    int? idContato,
    int? isPago,
    String? dtPagamento,
    String? contatoNome,
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
      if (idCategoria != null) 'id_categoria': idCategoria,
      if (idLocalOrigem != null) 'id_local_origem': idLocalOrigem,
      if (idLocalDestino != null) 'id_local_destino': idLocalDestino,
      if (idContato != null) 'id_contato': idContato,
      if (isPago != null) 'is_pago': isPago,
      if (dtPagamento != null) 'dt_pagamento': dtPagamento,
      if (contatoNome != null && contatoNome.isNotEmpty) 'contato_nome': contatoNome,
    };
    dev.log('createMovement: POST $uri');
    dev.log('createMovement body keys: ${body.keys.toList()}');
    dev.log('createMovement ids: categoria=$idCategoria, origem=$idLocalOrigem, destino=$idLocalDestino, contato=$idContato, tipoId=$idTipoMovimentacao');
    final http.Response res = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: json.encode(body));
    if (res.statusCode != 201) {
      throw Exception('Failed to create movement');
    }
  }

  Future<List<Contact>> fetchContacts() async {
    final Uri uri = buildGetContactsUri();
    final http.Response res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Failed to load contacts');
    }
    final List<dynamic> data = json.decode(res.body) as List<dynamic>;
    return data.map((e) => Contact.fromJson(e as Map<String, dynamic>)).toList();
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
    String? contatoNome,
  }) async {
    final String base = AppConstants.apiBaseUrl;
    final String path = AppConstants.createParcelamentoPath;
    final Uri uri = Uri.parse('$base/$path');
    final Map<String, dynamic> body = {
      'idpessoa': idpessoa,
      'tipo': tipo,
      'nome': nome,
      'descricao': descricao,
      'qtd_parcelas': qtdParcelas,
      'is_recorrente': recurrenceType.toLowerCase() != 'unica' ? 1 : 0,
      'recurrence_type': recurrenceType,
      'valor_parcela': valorParcela,
      'dt_inicio': dtInicio,
      'id_local_origem': idLocalOrigem,
      'id_local_destino': idLocalDestino,
      'id_contato': idContato,
      'id_tipo_movimentacao': idTipoMovimentacao,
      'id_categoria': idCategoria,
      if (contatoNome != null && contatoNome.isNotEmpty) 'contato_nome': contatoNome,
    };
    dev.log('createParcelamento: POST $uri');
    dev.log('createParcelamento body: ${body}');
    final http.Response res = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: json.encode(body));
    if (res.statusCode != 201) {
      throw Exception('Failed to create parcelamento');
    }
    return json.decode(res.body) as Map<String, dynamic>;
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