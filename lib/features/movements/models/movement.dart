class Movement {
  final int id;
  final int idpessoa;
  final int? idCategoria;
  final int? idParcelamento;
  final int? idLocalOrigem;
  final int? idLocalDestino;
  final int? idContato;
  final String tipoMovimentacao;
  final String nomeMovimentacao;
  final String? dscMovimentacao;
  final String dtMovimentacao;
  final String? dtVencimento;
  final double valor;
  final bool isPago;
  final String? dtPagamento;
  final String? contatoNome;

  const Movement({
    required this.id,
    required this.idpessoa,
    this.idCategoria,
    this.idParcelamento,
    this.idLocalOrigem,
    this.idLocalDestino,
    this.idContato,
    required this.tipoMovimentacao,
    required this.nomeMovimentacao,
    this.dscMovimentacao,
    required this.dtMovimentacao,
    this.dtVencimento,
    required this.valor,
    required this.isPago,
    this.dtPagamento,
    this.contatoNome,
  });

  factory Movement.fromJson(Map<String, dynamic> json) {
    final dynamic idRaw = json['id'];
    if (idRaw == null) {
      throw FormatException('Movement parse error: id is null');
    }
    final dynamic idPessoaRaw = json['idpessoa'];
    if (idPessoaRaw == null) {
      throw FormatException('Movement parse error: idpessoa is null');
    }
    final String? tipo = json['tipo_movimentacao'] as String?;
    if (tipo == null || tipo.isEmpty) {
      throw FormatException('Movement parse error: tipo_movimentacao is null');
    }
    final String? nome = json['nome_movimentacao'] as String?;
    if (nome == null || nome.isEmpty) {
      throw FormatException('Movement parse error: nome_movimentacao is null');
    }
    final String? dtMov = json['dt_movimentacao'] as String?;
    if (dtMov == null || dtMov.isEmpty) {
      throw FormatException('Movement parse error: dt_movimentacao is null');
    }
    final dynamic valorRaw = json['valor'];
    if (valorRaw == null) {
      throw FormatException('Movement parse error: valor is null');
    }
    final bool pago = ((json['is_pago'] as num?)?.toInt() ?? 0) == 1;
    return Movement(
      id: (idRaw as num).toInt(),
      idpessoa: (idPessoaRaw as num).toInt(),
      idCategoria: json['id_categoria'] == null ? null : (json['id_categoria'] as num).toInt(),
      idParcelamento: json['id_parcelamento'] == null ? null : (json['id_parcelamento'] as num).toInt(),
      idLocalOrigem: json['id_local_origem'] == null ? null : (json['id_local_origem'] as num).toInt(),
      idLocalDestino: json['id_local_destino'] == null ? null : (json['id_local_destino'] as num).toInt(),
      idContato: json['id_contato'] == null ? null : (json['id_contato'] as num).toInt(),
      tipoMovimentacao: tipo,
      nomeMovimentacao: nome,
      dscMovimentacao: json['dsc_movimentacao'] as String?,
      dtMovimentacao: dtMov,
      dtVencimento: json['dt_vencimento'] as String?,
      valor: (valorRaw as num).toDouble(),
      isPago: pago,
      dtPagamento: json['dt_pagamento'] as String?,
      contatoNome: json['contato_nome'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idpessoa': idpessoa,
      'id_categoria': idCategoria,
      'id_parcelamento': idParcelamento,
      'id_local_origem': idLocalOrigem,
      'id_local_destino': idLocalDestino,
      'id_contato': idContato,
      'tipo_movimentacao': tipoMovimentacao,
      'nome_movimentacao': nomeMovimentacao,
      'dsc_movimentacao': dscMovimentacao,
      'dt_movimentacao': dtMovimentacao,
      'dt_vencimento': dtVencimento,
      'valor': valor,
      'is_pago': isPago ? 1 : 0,
      'dt_pagamento': dtPagamento,
      'contato_nome': contatoNome,
    };
  }
}