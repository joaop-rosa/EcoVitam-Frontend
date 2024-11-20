class ArticleDetailed {
  final int id;
  final String titulo;
  final String imagemUrl;
  final String conteudo;
  final String nomeCompleto;
  final int total_likes;
  final int total_dislikes;
  final bool? user_feedback;

  ArticleDetailed({
    required this.id,
    required this.titulo,
    required this.imagemUrl,
    required this.conteudo,
    required this.nomeCompleto,
    required this.total_likes,
    required this.total_dislikes,
    required this.user_feedback,
  });

  // Fábrica para criar instância de ArticleDetailed a partir de um JSON
  factory ArticleDetailed.fromJson(Map<String, dynamic> json) {
    bool? getFeedback(dynamic feedback) {
      if (feedback == 1) {
        return true;
      }

      if (feedback == 0) {
        return false;
      }

      return null;
    }

    return ArticleDetailed(
        id: json['id'],
        nomeCompleto: json['nome_completo'],
        imagemUrl: json['imagemUrl'],
        conteudo: json['conteudo'],
        titulo: json['titulo'],
        total_likes: json['total_likes'],
        total_dislikes: json['total_dislikes'],
        user_feedback: getFeedback(json['user_feedback']));
  }

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
