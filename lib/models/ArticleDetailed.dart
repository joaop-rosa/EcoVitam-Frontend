class ArticleDetailed {
  final int id;
  final String titulo;
  final String imagemUrl;
  final String conteudo;
  final String nomeCompleto;

  ArticleDetailed({
    required this.id,
    required this.titulo,
    required this.imagemUrl,
    required this.conteudo,
    required this.nomeCompleto,
  });

  // Fábrica para criar instância de ArticleDetailed a partir de um JSON
  factory ArticleDetailed.fromJson(Map<String, dynamic> json) {
    return ArticleDetailed(
      id: json['id'],
      nomeCompleto: json['nome_completo'],
      imagemUrl: json['imagemUrl'],
      conteudo: json['conteudo'],
      titulo: json['titulo'],
    );
  }

  // Converte a instância de ArticleDetailed para JSON
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
