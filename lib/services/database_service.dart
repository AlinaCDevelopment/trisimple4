import 'dart:convert';

import 'package:app_4/models/event_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/database/equipamento.dart';
import '../models/database/evento.dart';

//TODO Fix get estado euipamento

//AS SERVICE

class DatabaseService {
  DatabaseService._privateConstructor();

  static final DatabaseService instance = DatabaseService._privateConstructor();

  final _baseAPI = 'http://dev.trisimple.pt';
  Future<List<Equipamento>?> readEquips() async {
    try {
      List<Equipamento> equipamentos = List.empty(growable: true);

      final result = await http.get(Uri.parse('$_baseAPI/equipamentos'));

      print(result.body);

      final List<dynamic> resultJson = json.decode(result.body);
      for (var equipJson in resultJson) {
        final estadoEquip =
            await _getEstadoEquip(equipJson['id_estado'] as int? ?? 1);
        final tipoEquip =
            await _getTipoEquip(equipJson['id_tipo'] as int? ?? 1);

        equipamentos.add(Equipamento(
            id: equipJson['id'],
            numeroEquipamento: equipJson['numero_equipamento'],
            tipoEquipamento: tipoEquip,
            estadoEquipamento: estadoEquip));
      }
      return equipamentos;
    } catch (e) {
      print('readEquips ERROR: $e');
    }
  }

  Future<List<Evento>?> readEventos() async {
    try {
      List<Evento> eventos = List.empty(growable: true);

      final result = await http.get(Uri.parse('$_baseAPI/eventos'));
      print(result.body);
      final List<dynamic> resultJson = json.decode(result.body);

      for (var equipJson in resultJson) {
        eventos.add(Evento(id: equipJson['id'], nome: equipJson['nome']));
      }
      return eventos;
    } catch (e) {
      print('readEventos: $e');
    }
  }

  Future<Evento?> readEventoById(int id) async {
    return (await readEventos())?.singleWhere((element) => element.id == id);
  }

  Future<Equipamento?> readEquipById(int id) async {
    return (await readEquips())?.singleWhere((element) => element.id == id);
  }

  Future<String> _getEstadoEquip(int idEstado) async {
    try {
      final result = await http.get(Uri.parse('$_baseAPI/estado_equipamento'));
      print(result.body);
      //TODO Pass where paramter instead of using where in the list
      List<dynamic> estados = json.decode(result.body);
      final estadoJson = estados.singleWhere((element) {
        final int idFound = element['id'] as int? ?? 0;
        return (idFound) == idEstado;
      });
      return estadoJson['estado_equipamento'];
    } catch (e) {
      print("_getEstadoEquip-Erro: $e");
    }
    return '';
  }

  Future<String> _getTipoEquip(int idTipo) async {
    final result = await http.get(Uri.parse('$_baseAPI/tipo_equipamento'));
    //TODO Pass where paramter instead of using where in the list
    List<dynamic> estados = json.decode(result.body);
    final estadoJson =
        estados.singleWhere((element) => element['id'] == idTipo);
    return estadoJson['tipo_equipamento'];
  }

  Future<bool> tryLogin(String password) async {
    final result = await http.get(Uri.parse('$_baseAPI/login/$password'));
    print(result.body);
    final isPasswordCorrect = json.decode(result.body)['sucess'] == 1;
    return isPasswordCorrect;
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
    try {
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
    } catch (e) {
      print('ERRRRRRRO: $e');
    }
    state = state.copyWith(equipamentos: equipamentos);
    return equipamentos;
  }

  Future<List<Evento>> readEventos() async {
    List<Evento> eventos = List.empty(growable: true);
    try {
      final result = await http.get(Uri.parse('$_baseAPI/eventos'));
      final resultJson = json.decode(result.body);

      resultJson.forEach((equipJson) async {
        eventos.add(Evento(id: equipJson['id'], nome: equipJson['nome']));
      });
    } catch (e) {
      print(e);
    }
    state = state.copyWith(eventos: eventos);
    return eventos;
  }

  Future<String> _getEstadoEquip(int idEstado) async {
    try {
      final result = await http.get(Uri.parse('$_baseAPI/estado_equipamento'));
      print(result.body);
      //TODO Pass where paramter instead of using where in the list
      List<dynamic> estados = json.decode(result.body);
      final estadoJson = estados.singleWhere((element) {
        final int idFound = element['id'] as int? ?? 0;
        return (idFound) == idEstado;
      });
      return estadoJson['estado_equipamento'];
    } catch (e) {
      print(e);
    }
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
