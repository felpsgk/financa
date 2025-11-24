class Contact {
  final int id;
  final String nome;
  const Contact({required this.id, required this.nome});
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(id: (json['id'] as num).toInt(), nome: json['nome'] as String);
  }
}