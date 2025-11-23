class MovementType {
  final int id;
  final String nome;
  final bool isEntrada;

  const MovementType({required this.id, required this.nome, required this.isEntrada});

  factory MovementType.fromJson(Map<String, dynamic> json) {
    final dynamic v = json['isEntrada'];
    final bool entrada;
    if (v is num) {
      entrada = v.toInt() == 1;
    } else if (v is String) {
      entrada = v == '1' || v.toLowerCase() == 'true';
    } else if (v is bool) {
      entrada = v;
    } else {
      entrada = false;
    }
    return MovementType(
      id: (json['id'] as num).toInt(),
      nome: json['nome'] as String,
      isEntrada: entrada,
    );
  }
}