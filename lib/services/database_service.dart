import 'dart:convert';

import '../models/database/estado_equipamento.dart';
import '../models/database/tipo_equipamento.dart';
import '../models/event_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/database/equipamento.dart';
import '../models/database/evento.dart';

class DatabaseService {
  DatabaseService._privateConstructor();

  static final DatabaseService instance = DatabaseService._privateConstructor();

  final _baseAPI = 'http://dev.trisimple.pt';

  Future<bool> setTicketId(String braceletId, String uniqueCode) async {
    final result =
        await http.put(Uri.parse('$_baseAPI/pulseira-bilhete'), headers: {
      "id_pulseira": 'test',
      "uniqueCode": '637cbf577b3d9',
    });

    print("resuuuuult:${result.body}");
    final json = jsonDecode(result.body);
    return json['sucess'];
  }

  Future<List<Equipamento>> getEquips() async {
    final result = await http.get(Uri.parse('$_baseAPI/equipamentos'));
    return _generateEquips(result.body);
  }

  Future<List<Equipamento>> _generateEquips(String resultBody) async {
    List<Equipamento> equipamentos = List.empty(growable: true);

    final List<dynamic> resultJson = json.decode(resultBody);
    for (var equipJson in resultJson) {
      final estadoEquip =
          await _getEstadoEquip(equipJson['id_estado'] as int? ?? 1);
      final tipoEquip = await _getTipoEquip(equipJson['id_tipo'] as int? ?? 1);

      equipamentos.add(Equipamento(
          id: equipJson['id'],
          numeroEquipamento: equipJson['numero_equipamento'],
          tipoEquipamento: tipoEquip,
          estadoEquipamento: estadoEquip));
    }
    return equipamentos;
  }

  Future<List<Equipamento>> getEquipsByEvento(String idEvento) async {
    final result =
        await http.get(Uri.parse('$_baseAPI/equipamentos-evento/$idEvento'));

    return _generateEquips(result.body);
  }

  Future<List<Evento>?> readEventos() async {
    List<Evento> eventos = List.empty(growable: true);

    final result = await http.get(Uri.parse('$_baseAPI/eventos'));
    final List<dynamic> resultJson = json.decode(result.body);

    for (var equipJson in resultJson) {
      eventos.add(Evento(id: equipJson['id'], nome: equipJson['nome']));
    }
    return eventos;
  }

  Future<Evento?> readEventoById(int id) async {
    return (await readEventos())?.singleWhere((element) => element.id == id);
  }

  Future<Equipamento?> readEquipById(int id) async {
    //TODO ASK FOR THIS ENDPOINT
    return (await getEquips()).singleWhere((element) => element.id == id);
  }

  Future<String> _getEstadoEquip(int idEstado) async {
    final result = await http.get(Uri.parse('$_baseAPI/estado_equipamento'));
    //TODO Pass where paramter instead of using where in the list

    final List<dynamic> resultJson = json.decode(result.body);

    List<EstadoEquipamento> estados =
        List<EstadoEquipamento>.empty(growable: true);

    for (var equipJson in resultJson) {
      estados.add(EstadoEquipamento(
          id: equipJson['id'],
          estadoEquipamento: equipJson['estado_equipamento']));
    }
    final estadoJson = estados.singleWhere((element) => element.id == idEstado);
    return estadoJson.estadoEquipamento;
  }

  Future<String> _getTipoEquip(int idTipo) async {
    final result = await http.get(Uri.parse('$_baseAPI/tipo_equipamento'));
    //TODO Pass where paramter instead of using where in the list

    final List<dynamic> resultJson = json.decode(result.body);

    List<TipoEquipamento> tipos = List<TipoEquipamento>.empty(growable: true);

    for (var equipJson in resultJson) {
      tipos.add(TipoEquipamento(
          id: equipJson['id'], tipoEquipamento: equipJson['tipo_equipamento']));
    }
    final tipo = tipos.singleWhere((element) => element.id == idTipo);
    return tipo.tipoEquipamento;
  }

  Future<bool> tryLogin(String password) async {
    final result = await http.get(Uri.parse('$_baseAPI/login/$password'));
    final isPasswordCorrect = json.decode(result.body)['sucess'] == 1;
    return isPasswordCorrect;
  }

  Future<bool> trySend(String data) async {
    //TODO Try to send data to the API
    bool dataSent = false;
    return dataSent;
  }
}
