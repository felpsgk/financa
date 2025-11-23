class Category {
  final int id;
  final String nome;
  const Category({required this.id, required this.nome});
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: (json['id'] as num).toInt(), nome: json['nome'] as String);
  }
}