import 'dart:convert';


class EstadoEquipamento{
    late final int id;
    late final String estadoEquipamento;
    EstadoEquipamento({required this.id, required this.estadoEquipamento});

  EstadoEquipamento.fromJson(String jsonString) {
    final json = jsonDecode(jsonString);
    id = json['id'];
    estadoEquipamento = json['estado_equipamento'];
  }
  String toJson() {
    final map = {
      'id': id,
      'estado_equipamento': estadoEquipamento,
    };
    return jsonEncode(map);
  }
}