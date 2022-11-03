class Evento {
  late final String nome;
  late final int id;
  Evento({required this.id, required this.nome});

  Evento.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
    };
  }
}
