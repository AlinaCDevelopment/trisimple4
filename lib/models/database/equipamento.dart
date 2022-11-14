import 'dart:convert';

class Equipamento {
  late final int id;
  late final String numeroEquipamento;
  late final String tipoEquipamento;
  late final String estadoEquipamento;

  Equipamento(
      {required this.id,
      required this.numeroEquipamento,
      required this.tipoEquipamento,
      required this.estadoEquipamento});

  Equipamento.fromJson(String jsonString) {
    final json = jsonDecode(jsonString);
    id = json['id'];
    numeroEquipamento = json['numero_equipamento'];
    tipoEquipamento = json['tipo_equipamento'];
    estadoEquipamento = json['estado_equipamento'];
  }
  String toJson() {
    final map = {
      'id': id,
      'numero_equipamento': numeroEquipamento,
      'tipo_equipamento': tipoEquipamento,
      'estado_equipamento': estadoEquipamento,
    };
    return jsonEncode(map);
  }
}
