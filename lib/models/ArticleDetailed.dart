class Article {
  final int id;
  final String titulo;
  final String imagemUrl;
  final String conteudo;
  final String nomeCompleto;

  Article({
    required this.id,
    required this.titulo,
    required this.imagemUrl,
    required this.conteudo,
    required this.nomeCompleto,
  });

  // Fábrica para criar instância de Article a partir de um JSON
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      nomeCompleto: json['nome_completo'],
      imagemUrl: json['imagemUrl'],
      conteudo: json['conteudo'],
      titulo: json['titulo'],
    );
  }

  // Converte a instância de Article para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome_completo': nomeCompleto,
      'imagemUrl': imagemUrl,
      'conteudo': conteudo,
      'titulo': titulo,
    };
  }
}
