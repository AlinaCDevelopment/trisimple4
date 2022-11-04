import 'dart:convert';

import 'package:app_4/models/database/equipamento.dart';
import 'package:app_4/services/database_service.dart';
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
    final prefs = await SharedPreferences.getInstance();
    final equipamentoId = prefs.getInt('equipamento');
    final eventoId = prefs.getInt('evento');
    print('equipamento: $equipamentoId');
    print('evento: $eventoId');
    AuthState authState;
    if (equipamentoId != null && eventoId != null) {
      final equipamento =
          await DatabaseService.instance.readEquipById(equipamentoId);
      final evento = await DatabaseService.instance.readEventoById(eventoId);
      authState = AuthState(equipamento: equipamento, evento: evento);
    } else {
      authState = AuthState();
    }
    this.state = authState;
    return authState.equipamento != null && authState.evento != null;
  }

  Future<bool> authenticate(
      {required Equipamento equipamento,
      required Evento evento,
      required String password}) async {
    this.state = AuthState(equipamento: equipamento, evento: evento);

    final isPasswordCorrect = await DatabaseService.instance.tryLogin(password);
    if (isPasswordCorrect) {
      final authSet = await _setDeviceAuth(equipamento.id, evento.id);
      return authSet;
    }
    return false;
  }

  Future<void> resetAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('equipamento');
    await prefs.remove('evento');
  }

  Future<bool> _setDeviceAuth(int deviceId, int eventId) async {
    final prefs = await SharedPreferences.getInstance();
    final equipSet = await prefs.setInt('equipamento', deviceId);
    final eventoSet = await prefs.setInt('evento', eventId);
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
