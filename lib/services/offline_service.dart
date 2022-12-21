import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'database_service.dart';

class OfflineService {
  var _isInitiated = false;
  late Database _database;
  OfflineService._privateConstructor();

  static final OfflineService instance = OfflineService._privateConstructor();

  Future<void> setPending(int idBilhete, DateTime latestEntrance) async {
    _database.rawInsert(
        'INSERT INTO pending VALUES ($idBilhete, "${latestEntrance.toIso8601String()}")');
  }

  Future<int> getPendingCount() async {
    return Sqflite.firstIntValue(
            await _database.rawQuery('SELECT COUNT(*) FROM pending')) ??
        0;
  }

  ///Sends the pending data to the server
  ///
  ///Returns: the number of records sent
  Future<int> sendPending() async {
    //TODO FIX
    final pendingElements = await getPending();
    var pendingSent = 0;
    for (final pending in pendingElements) {
      try {
        var e = pending['id_bilhete'];
        print(e.runtimeType);
        final idBilhete = pending['id_bilhete'] as int;
        final entrance = pending['entrance'] as String;

        final success = await DatabaseService.instance.sendEntrance(
            idBilhete, DateTime.parse(entrance));

        if (success) {
          await _database
              .rawDelete('DELETE FROM pending WHERE entrance = "$entrance"');
          pendingSent += 1;
        }
      } catch (e) {
        print('sending pending: $e');
        throw (e);
      }
    }
    return pendingSent;
  }

  Future<void> init() async {
    if (!_isInitiated) {
      _database = await openDatabase(
        join(await getDatabasesPath(), 'Trisimple4Data_Tables.db'),
        onCreate: (db, version) async {
          await db.execute(
              'CREATE TABLE pending (id_bilhete INTEGER, entrance TEXT PRIMARY KEY)');
        },
        version: 2,
      );
      _isInitiated = true;
    }
  }

//TODO ORDER BY DATETIMES FROM OLDEST TO MOST RECENT
  Future<List<Map<String, Object?>>> getPending() async {
    var pendingData = await _database.rawQuery('SELECT * FROM pending');
    pendingData = List.of(pendingData, growable: true);
    pendingData.sort((a, b) {
      final dateA = DateTime.parse(a['entrance']! as String);
      final dateB = DateTime.parse(b['entrance']! as String);
      return -dateA.compareTo(dateB);
    });
    return pendingData;
  }
}
