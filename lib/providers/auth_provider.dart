import 'dart:convert';

import '../models/database/equipamento.dart';
import '../services/database_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/database/evento.dart';

class AuthState {
  final Equipamento? equipamento;
  // final int deviceId;
  final Evento? evento;
  AuthState({
    this.equipamento,
    this.evento,
  });
}

@immutable
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<bool> authenticateFromPreviousLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final equipJsonString = prefs.getString('equipamento');
      final eventoJsonString = prefs.getString('evento');
      AuthState authState;
      if (equipJsonString != null && eventoJsonString != null) {
        final equipamentoLocal = Equipamento.fromJson(equipJsonString);
        final eventoLocal = Evento.fromJson(eventoJsonString);

        final connectivity = await Connectivity().checkConnectivity();
        final isConnected = connectivity == ConnectivityResult.wifi;
        //If wifi is available get the latest version of the event and equipment from the database
        //Else use the ones stored inside the preferences
        try {
          if (isConnected) {
            final equipamento = await DatabaseService.instance
                .readEquipById(equipamentoLocal.id);
            final evento =
                await DatabaseService.instance.readEventoById(eventoLocal.id);
            authState = AuthState(equipamento: equipamento, evento: evento);
          } else {
            authState =
                AuthState(equipamento: equipamentoLocal, evento: eventoLocal);
          }
        } catch (e) {
          authState =
              AuthState(equipamento: equipamentoLocal, evento: eventoLocal);
          print(e);
        }
      } else {
        authState = AuthState();
      }

      state = authState;
      return authState.equipamento != null && authState.evento != null;
    } catch (e) {
      resetAuth();
      return false;
    }
  }

  Future<bool> authenticate(
      {required Equipamento equipamento,
      required Evento evento,
      required String password}) async {
    this.state = AuthState(equipamento: equipamento, evento: evento);

    final isPasswordCorrect = await DatabaseService.instance.tryLogin(password);
    if (isPasswordCorrect) {
      final authSet = await _setDeviceAuth(equipamento, evento);
      return authSet;
    }
    return false;
  }

  Future<void> resetAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('equipamento');
    await prefs.remove('evento');
    state = AuthState();
  }

  Future<bool> _setDeviceAuth(Equipamento equipamento, Evento evento) async {
    final prefs = await SharedPreferences.getInstance();
    final equipSet = await prefs.setString('equipamento', equipamento.toJson());
    final eventoSet = await prefs.setString('evento', evento.toJson());
    if (eventoSet && equipSet) {
      await authenticateFromPreviousLogs();
      return true;
    } else {
      return false;
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
