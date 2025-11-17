class Movement {
  final int id;
  final int idpessoa;
  final String tipoMovimentacao;
  final String nomeMovimentacao;
  final String? dscMovimentacao;
  final String dtMovimentacao;
  final String? dtVencimento;
  final double valor;

  const Movement({
    required this.id,
    required this.idpessoa,
    required this.tipoMovimentacao,
    required this.nomeMovimentacao,
    required this.dscMovimentacao,
    required this.dtMovimentacao,
    required this.dtVencimento,
    required this.valor,
  });

  factory Movement.fromJson(Map<String, dynamic> json) {
    return Movement(
      id: (json['id'] as num).toInt(),
      idpessoa: (json['idpessoa'] as num).toInt(),
      tipoMovimentacao: json['tipo_movimentacao'] as String,
      nomeMovimentacao: json['nome_movimentacao'] as String,
      dscMovimentacao: json['dsc_movimentacao'] as String?,
      dtMovimentacao: json['dt_movimentacao'] as String,
      dtVencimento: json['dt_vencimento'] as String?,
      valor: (json['valor'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idpessoa': idpessoa,
      'tipo_movimentacao': tipoMovimentacao,
      'nome_movimentacao': nomeMovimentacao,
      'dsc_movimentacao': dscMovimentacao,
      'dt_movimentacao': dtMovimentacao,
      'dt_vencimento': dtVencimento,
      'valor': valor,
    };
  }
}