class Article {
  final int id;
  final String titulo;
  final String imagemUrl;

  Article({
    required this.id,
    required this.titulo,
    required this.imagemUrl,
  });

  // Fábrica para criar instância de Article a partir de um JSON
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      imagemUrl: json['imagemUrl'],
      titulo: json['titulo'],
    );
  }

  // Converte a instância de Article para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagemUrl': imagemUrl,
      'titulo': titulo,
    };
  }
}
