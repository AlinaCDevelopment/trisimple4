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
    final json = jsonDecode(result.body);
    return json['sucess'];
  }

  Future<List<Equipamento>> getEquips({int? idEvento, int? idEquip}) async {
    final result = await http.get(Uri.parse(
        '$_baseAPI/equipamentos-esntl?id_evento=$idEvento&id_equipamento=$idEquip'));

    List<Equipamento> equipamentos = List.empty(growable: true);

    final List<dynamic> resultJson = json.decode(result.body);
    for (var equipJson in resultJson) {
      equipamentos.add(Equipamento(
          id: equipJson['id'],
          numeroEquipamento: equipJson['numero_equipamento'],
          tipo: equipJson['tipo'],
          estado: equipJson['estado']));
    }
    return equipamentos;
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
    //TODO CREATE THIS ENDPOINT
    return (await readEventos())?.singleWhere((element) => element.id == id);
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
