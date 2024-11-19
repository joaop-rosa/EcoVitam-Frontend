class CollectionPoint {
  final int id;
  final String pontoColetaNome;
  final String endereco;
  final String estado;
  final String cidade;
  final String contato;
  final String nomeCompleto;
  final int total_likes;
  final bool is_user_liked;

  CollectionPoint({
    required this.id,
    required this.pontoColetaNome,
    required this.endereco,
    required this.estado,
    required this.cidade,
    required this.contato,
    required this.nomeCompleto,
    required this.total_likes,
    required this.is_user_liked,
  });

  factory CollectionPoint.fromJson(Map<String, dynamic> json) {
    return CollectionPoint(
      id: json['id'],
      pontoColetaNome: json['pontoColetaNome'],
      endereco: json['endereco'],
      estado: json['estado'],
      cidade: json['cidade'],
      contato: json['contato'],
      nomeCompleto: json['nome_completo'],
      total_likes: json['total_likes'],
      is_user_liked: json['is_user_liked'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pontoColetaNome': pontoColetaNome,
      'endereco': endereco,
      'estado': estado,
      'cidade': cidade,
      'contato': contato,
    };
  }
}
