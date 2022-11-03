import 'dart:convert';

import 'package:app_4/models/database/equipamento.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/database/evento.dart';

class AuthData {
  final Equipamento equipamento;
  // final int deviceId;
  final Evento evento;
  // final int eventId;
  AuthData({
    required this.equipamento,
    //   required this.deviceId,
    required this.evento,
    //  required this.eventId,
  });
}

class AuthState {
  final AuthData? authData;

  AuthState({this.authData});
}

@immutable
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<bool> authenticateFromPreviousLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final equipamentoJson = prefs.getString('equipamento');
    final eventoJson = prefs.getString('evento');
    print('equipamento: $equipamentoJson');
    print('evento: $eventoJson');
    AuthState authState;
    if (equipamentoJson != null &&
        eventoJson != null &&
        equipamentoJson.isNotEmpty &&
        eventoJson.isNotEmpty) {
      final equipamento = Equipamento.fromJson(json.decode(equipamentoJson));
      final evento = Evento.fromJson(json.decode(eventoJson));
      authState = AuthState(
          authData: AuthData(equipamento: equipamento, evento: evento));
    } else {
      authState = AuthState();
    }
    this.state = authState;
    return authState.authData != null;
  }

  Future<bool> authenticate(
      {required Equipamento equipamento,
      required Evento evento,
      required String password}) async {

    this.state =
        AuthState(authData: AuthData(equipamento: equipamento, evento: evento));
    await _setDeviceAuth(
        json.encode(equipamento.toJson()), json.encode(evento.toJson()));
    return true;
  }

  Future<void> resetAuth() async {
    await _setDeviceAuth('', '');
  }

  Future<void> _setDeviceAuth(String device, String event) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('equipamento', device);
    await prefs.setString('evento', event);
    await authenticateFromPreviousLogs();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
