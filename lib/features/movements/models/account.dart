class Account {
  final int id;
  final String nome;
  const Account({required this.id, required this.nome});
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(id: (json['id'] as num).toInt(), nome: json['nome'] as String);
  }
}