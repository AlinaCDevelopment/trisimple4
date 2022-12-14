import 'dart:convert';

class TipoEquipamento {
  late final int id;
  late final String tipoEquipamento;
  TipoEquipamento({required this.id, required this.tipoEquipamento});

  TipoEquipamento.fromJson(String jsonString) {
    final json = jsonDecode(jsonString);
    id = json['id'];
    tipoEquipamento = json['tipo_equipamento'];
  }
  String toJson() {
    final map = {
      'id': id,
      'tipo_equipamento': tipoEquipamento,
    };
    return jsonEncode(map);
  }
}
