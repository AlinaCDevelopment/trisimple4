import 'dart:convert';

import 'package:app_4/models/database/estado_equipamento.dart';
import 'package:app_4/models/database/tipo_equipamento.dart';
import 'package:app_4/models/event_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/database/equipamento.dart';
import '../models/database/evento.dart';

//AS SERVICE

class DatabaseService {
  DatabaseService._privateConstructor();

  static final DatabaseService instance = DatabaseService._privateConstructor();

  final _baseAPI = 'http://dev.trisimple.pt';
  Future<List<Equipamento>?> readEquips() async {
    List<Equipamento> equipamentos = List.empty(growable: true);

    final result = await http.get(Uri.parse('$_baseAPI/equipamentos'));


    final List<dynamic> resultJson = json.decode(result.body);
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
    return (await readEquips())?.singleWhere((element) => element.id == id);
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

//AS PROVIDER

@immutable
class DatabaseState {
  final Iterable<Equipamento>? equipamentos;
  final Iterable<Evento>? eventos;
  final Iterable<EventTag>? tags;

  const DatabaseState({this.equipamentos, this.eventos, this.tags});

  DatabaseState copyWith({
    Iterable<Equipamento>? equipamentos,
    Iterable<Evento>? eventos,
    Iterable<EventTag>? tags,
  }) {
    return DatabaseState(
      equipamentos: equipamentos ?? this.equipamentos,
      eventos: eventos ?? this.eventos,
      tags: tags ?? this.tags,
    );
  }
}

@immutable
class DatabaseNotifier extends StateNotifier<DatabaseState> {
  final _baseAPI = 'https://dev.trisimple.pt';
  DatabaseNotifier() : super(const DatabaseState());

  Future<List<Equipamento>> readEquips() async {
    List<Equipamento> equipamentos = List.empty(growable: true);
      final result = await http.get(Uri.parse('$_baseAPI/equipamentos'));
      final resultJson = json.decode(result.body);
      resultJson.forEach((equipJson) async {
        final estadoEquip =
            await _getEstadoEquip(equipJson['id_estado'] as int? ?? 1);
        final tipoEquip =
            await _getTipoEquip(equipJson['id_tipo'] as int? ?? 1);

        equipamentos.add(Equipamento(
            id: equipJson['id'],
            numeroEquipamento: equipJson['numero_equipamento'],
            tipoEquipamento: tipoEquip,
            estadoEquipamento: estadoEquip));
      });
    state = state.copyWith(equipamentos: equipamentos);
    return equipamentos;
  }

  Future<List<Evento>> readEventos() async {
    List<Evento> eventos = List.empty(growable: true);
      final result = await http.get(Uri.parse('$_baseAPI/eventos'));
      final resultJson = json.decode(result.body);

      resultJson.forEach((equipJson) async {
        eventos.add(Evento(id: equipJson['id'], nome: equipJson['nome']));
      });
    state = state.copyWith(eventos: eventos);
    return eventos;
  }

  Future<String> _getEstadoEquip(int idEstado) async {
      final result = await http.get(Uri.parse('$_baseAPI/estado_equipamento'));
      //TODO Pass where paramter instead of using where in the list
      List<dynamic> estados = json.decode(result.body);
      final estadoJson = estados.singleWhere((element) {
        final int idFound = element['id'] as int? ?? 0;
        return (idFound) == idEstado;
      });
      return estadoJson['estado_equipamento'];
    return 'unavailable';
  }

  Future<String> _getTipoEquip(int idTipo) async {
    final result = await http.get(Uri.parse('$_baseAPI/tipo_equipamento'));
    //TODO Pass where paramter instead of using where in the list
    List<dynamic> estados = json.decode(result.body);
    final estadoJson =
        estados.singleWhere((element) => element['id'] == idTipo);
    return estadoJson['tipo_equipamento'];
  }
}

final databaseProvider =
    StateNotifierProvider<DatabaseNotifier, DatabaseState>((ref) {
  return DatabaseNotifier();
});
