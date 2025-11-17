import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants.dart';
import '../models/movement.dart';

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

  Future<List<Movement>> fetchMovements({required int idpessoa, String? startDate, String? endDate}) async {
    final Uri uri = buildGetMovementsUri(idpessoa, startDate: startDate, endDate: endDate);
    print('uri: $uri');
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
    };
    final http.Response res = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: json.encode(body));
    if (res.statusCode != 201) {
      throw Exception('Failed to create movement');
    }
  }
}