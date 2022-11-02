import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/database/device.dart';
import '../models/database/event.dart';

@immutable
class DatabaseState {
  final Iterable<Device>? devices;
  final Iterable<Event>? events;
  final Iterable<Device>? tags;

  const DatabaseState._({this.devices, this.events, this.tags});

  DatabaseState copyWith({
    Iterable<Device>? devices,
    Iterable<Event>? events,
    Iterable<Device>? tags,
  }) {
    return DatabaseState._(
      devices: devices ?? this.devices,
      events: events ?? this.events,
      tags: tags ?? this.tags,
    );
  }
}

@immutable
class DatabaseNotifier extends StateNotifier<DatabaseState> {
  final _baseAPI = 'https://dev.trisimple.pt';
  DatabaseNotifier(super.state);
  Future<void> readDevices() async {
    List<Device> devices = List.empty(growable: true);
    final result = await http.get(Uri.https('$_baseAPI/equipamentos'));
    final Map<String, dynamic> resultJson = json.decode(result.body);
    resultJson.keys.map(
      (e) {
        devices.add(Device());
      },
    );
    state = state.copyWith(devices: devices);
  }

  Future<void> readEvents() async {
    List<Event> events = List.empty(growable: true);
    final result = await http.get(Uri.https('$_baseAPI/eventos'));
    final Map<String, dynamic> resultJson = json.decode(result.body);
    resultJson.keys.map(
      (e) {
        events.add(Event());
      },
    );
    state = state.copyWith(events: events);
  }
}

 /*  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'devices': devices.toMap()});
    result.addAll({'events': events.toMap()});
    result.addAll({'tags': tags.toMap()});

    return result;
  } */

 /*  factory DatabaseState.fromMap(Map<String, dynamic> map) {
    return DatabaseState(
      devices: Iterable<Device>.fromMap(map['devices']),
      events: Iterable<Device>.fromMap(map['events']),
      tags: Iterable<Device>.fromMap(map['tags']),
    );
  }

  String toJson() => json.encode(toMap());

  factory DatabaseState.fromJson(String source) =>
      DatabaseState.fromMap(json.decode(source));

  @override
  String toString() =>
      'DatabaseState(devices: $devices, events: $events, tags: $tags)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DatabaseState &&
        other.devices == devices &&
        other.events == events &&
        other.tags == tags;
  }

  @override
  int get hashCode => devices.hashCode ^ events.hashCode ^ tags.hashCode;
}

const _baseAPI = 'https://dev.trisimple.pt';

class DatabaseService {
  Future<List<Device>> getDevices() async {
    List<Device> devices = List.empty(growable: true);
    final result = await http.get(Uri.https('$_baseAPI/equipamentos'));
    final resultJson = jsonDecode(result.body);
    print(resultJson);
    return devices;
  }
}
 */