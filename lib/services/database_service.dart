import 'dart:convert';

import '../models/database/device.dart';
import 'package:http/http.dart' as http;

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
