class User {
  final int id;
  final String nome;
  final DateTime data_nascimento;
  final String estado;
  final String cidade;
  final bool is_admin;

  User({
    required this.id,
    required this.nome,
    required this.data_nascimento,
    required this.estado,
    required this.cidade,
    required this.is_admin,
  });

  // Fábrica para criar instância de User a partir de um JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nome: '${json['primeiro_nome']} ${json['ultimo_nome']}',
      data_nascimento: DateTime.parse(json['data_nascimento']),
      estado: json['estado'],
      cidade: json['cidade'],
      is_admin: json['is_admin'] == 1 ? true : false,
    );
  }

  // Converte a instância de User para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'data_nascimento': data_nascimento,
      'estado': estado,
      'cidade': cidade,
      'is_admin': is_admin,
    };
  }
}
