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

  Equipamento.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    numeroEquipamento = json['numero_equipamento'];
    tipoEquipamento = json['tipo_equipamento'];
    estadoEquipamento = json['estado_equipamento'];
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
