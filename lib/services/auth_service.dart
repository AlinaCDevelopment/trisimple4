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
  final bool initialized;
  final AuthData? authData;

  AuthState({this.authData, required this.initialized});
}

@immutable
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(initialized: false));

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
          authData: AuthData(equipamento: equipamento, evento: evento),
          initialized: true);
    } else {
      authState = AuthState(initialized: true);
    }
    this.state = authState;
    return authState.authData != null;
  }

  Future<void> authenticate(
      {required String equipamento,
      required String evento,
      required String password}) async {
    await _setDeviceAuth(equipamento, evento);
  }

  Future<void> resetAuth() async {
    await _setDeviceAuth('', '');
  }

  Future<void> _setDeviceAuth(String device, String event) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('device', device);
    await prefs.setString('event', event);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
