import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

import '../constants/nfc_blocks.dart';
import '../models/event_tag.dart';
import '../services/l10n/app_localizations.dart';
import 'nfc_provider_base.dart';

@immutable
class NfcNotifierClassic extends NfcNotifierBase {
  //==================================================================================================================
  //MAIN METHODS
  @override
  Future<Bilhete> readTag({
    required NfcTag nfcTag,
  }) async {
    final mifareTag = MifareClassic.from(nfcTag)!;
    final id = await _readId(mifareTag);
    final ticketAndEventBytes = (await _readBlockAsBytes(mifareTag,
        storageSlot: ticketIdEventIdStorage));
    final ticketIdBytes =
        ticketAndEventBytes.getRange(0, 8).where((element) => element != 0);
    final eventIdBytes =
        ticketAndEventBytes.getRange(8, 15).where((element) => element != 0);
    final ticketId = int.parse(String.fromCharCodes(ticketIdBytes));
    final eventId = String.fromCharCodes(eventIdBytes);
    final startDate = await _readDateTime(mifareTag, starttDateStorage);
    final endDate = await _readDateTime(mifareTag, endDateStorage);
    final title =
        await _readBlockAsString(mifareTag, storageSlot: titleStorage);

    state = NfcState(
        tag: Bilhete(id, int.parse(eventId),
            title: title,
            ticketId: ticketId,
            startDate: startDate,
            endDate: endDate));
    return state.tag!;
  }

  Future<bool> isNfcAvailable() async {
    return await NfcManager.instance.isAvailable();
  }

  void reset() {
    state = NfcState();
  }

  //==================================================================================================================
  //PRIVATE METHODS

  Future<DateTime?> _readDateTime(
      MifareClassic mifare, NfcStorageSlot storageSlot) async {
    final dataString =
        (await _readBlockAsString(mifare, storageSlot: storageSlot));
    if (dataString == 'null') {
      return null;
    }
    print(int.parse(dataString));
    var date = DateTime.fromMillisecondsSinceEpoch(int.parse(dataString));
    return date;
  }

  Future<String> _readTitle(MifareClassic mifare) async {
    final title = await _readBlockAsString(mifare, storageSlot: titleStorage);
    return title;
  }

  Future<String> _readId(MifareClassic tag) async {
    final manufacturerData =
        await _readBlockAsBytes(tag, storageSlot: manufacturerBlockStorage);
    return manufacturerData.toString();
  }

  Future<String> _readBlockAsString(MifareClassic tag,
      {required NfcStorageSlot storageSlot}) async {
    var stringsRead = List<String>.empty(growable: true);
    final success = await tag.authenticateSectorWithKeyA(
        sectorIndex: storageSlot.sector, key: keyB);
    for (var block in storageSlot.blocksInSector) {
      final blockIndex = block + storageSlot.sector * 4;
      final data = await tag.readBlock(blockIndex: blockIndex);
      //   data.toList().removeWhere((element) => element == 16);
      final filteredData = List<int>.from(data, growable: true);
      filteredData.removeWhere((element) => element == 0);
      stringsRead.add(String.fromCharCodes(filteredData));
    }
    final dataString = stringsRead.join("");
    print(
        'DATA READ IN BLOCKS ${storageSlot.blocksInSector} IN SECTOR ${storageSlot.sector}: $dataString');
    return dataString;
  }

  Future<List<int>> _readBlockAsBytes(MifareClassic tag,
      {required NfcStorageSlot storageSlot}) async {
    var bytesRead = List<int>.empty(growable: true);
    for (var block in storageSlot.blocksInSector) {
      final success = await tag.authenticateSectorWithKeyA(
          sectorIndex: storageSlot.sector, key: keyB);

      final blockIndex = block + storageSlot.sector * 4;
      final data = (await tag.readBlock(blockIndex: blockIndex)).toList();
      data.removeWhere((element) => element == 16);
      bytesRead.addAll(data);
    }
    return bytesRead;
  }
}
