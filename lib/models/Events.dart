class Event {
  final int id;
  final String titulo;
  final String endereco;
  final String estado;
  final String cidade;
  final String contato;
  final DateTime data;
  final String horaInicio;
  final String horaFim;
  final String nomeCompleto;

  Event({
    required this.id,
    required this.titulo,
    required this.endereco,
    required this.estado,
    required this.cidade,
    required this.contato,
    required this.data,
    required this.horaInicio,
    required this.horaFim,
    required this.nomeCompleto,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      titulo: json['titulo'],
      endereco: json['endereco'],
      estado: json['estado'],
      cidade: json['cidade'],
      contato: json['contato'],
      data: DateTime.parse(json['data']),
      horaInicio: json['hora_inicio'],
      horaFim: json['hora_fim'],
      nomeCompleto: json['nome_completo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'endereco': endereco,
      'estado': estado,
      'cidade': cidade,
      'contato': contato,
      'data': data.toIso8601String(),
      'hora_inicio': horaInicio,
      'hora_fim': horaFim,
      'nome_completo': nomeCompleto,
    };
  }
}
