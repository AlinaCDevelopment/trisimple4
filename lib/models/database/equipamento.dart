import 'dart:convert';

class Equipamento {
  late final int id;
  late final String numeroEquipamento;
  late final String tipo;
  late final String estado;

  Equipamento(
      {required this.id,
      required this.numeroEquipamento,
      required this.tipo,
      required this.estado});

  Equipamento.fromJson(String jsonString) {
    final json = jsonDecode(jsonString);
    id = json['id'];
    numeroEquipamento = json['numero_equipamento'];
    tipo = json['tipo_equipamento'];
    estado = json['estado_equipamento'];
  }
  String toJson() {
    final map = {
      'id': id,
      'numero_equipamento': numeroEquipamento,
      'tipo_equipamento': tipo,
      'estado_equipamento': estado,
    };
    return jsonEncode(map);
  }
}
