import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthData {
  final String device;
  // final int deviceId;
  final String event;
  // final int eventId;
  AuthData({
    required this.device,
    //   required this.deviceId,
    required this.event,
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
    final device = prefs.getString('device');
    final event = prefs.getString('event');
    print('device: $device');
    print('event: $event');
    AuthState authState;
    if (device != null &&
        event != null &&
        device.isNotEmpty &&
        event.isNotEmpty) {
      authState = AuthState(
          authData: AuthData(device: device, event: event), initialized: true);
    } else {
      authState = AuthState(initialized: true);
    }
    this.state = authState;
    return authState.authData != null;
  }

  Future<void> authenticate(
      {required String device,
      required String event,
      required String password}) async {
    await _setDeviceAuth(device, event);
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
