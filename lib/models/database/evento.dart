import 'dart:convert';

class Evento {
  late final String nome;
  late final int id;
  Evento({required this.id, required this.nome});

  Evento.fromJson(String jsonString) {
    final jsonMap = json.decode(jsonString);
    id = jsonMap['id'];
    nome = jsonMap['nome'];
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
    };
  }
}
