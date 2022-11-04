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
    final jsonMap = json.decode(jsonString);
    id = jsonMap['id'];
    numeroEquipamento = jsonMap['numero_equipamento'];
    tipoEquipamento = jsonMap['tipo_equipamento'];
    estadoEquipamento = jsonMap['estado_equipamento'];
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero_equipamento': numeroEquipamento,
      'tipo_equipamento': tipoEquipamento,
      'estado_equipamento': estadoEquipamento,
    };
  }
}
