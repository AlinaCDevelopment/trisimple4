import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

import '../constants/nfc_blocks_ultralight.dart';
import '../models/event_tag.dart';
import 'nfc_provider_base.dart';

@immutable
class NfcNotifierUltralight extends NfcNotifierBase {
  //==================================================================================================================
  //MAIN METHODS
  @override
  Future<Bilhete> readTag({
    required NfcTag nfcTag,
  }) async {
    final mifareTag = MifareUltralight.from(nfcTag)!;
    final startDate = await _readDateTime(mifareTag, startDateBlock);
    final endDate = await _readDateTime(mifareTag, endDateBlock);
    final id = await _readId(nfcTag);
    final ticketId =
        int.parse(await _readBlock(block: ticketIdBlock, tag: mifareTag));
    final eventId = await _readBlock(block: eventIdBlock, tag: mifareTag);
    final title = await _readTitle(mifareTag);

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

  Future<DateTime?> _readDateTime(MifareUltralight mifare, int block) async {
    final dataString = await _readBlock(tag: mifare, block: block);
    if (dataString == 'null') {
      return null;
    }
    print(int.parse(dataString));
    //Multiply by 10 because we're losing a 0 when reading
    var date = DateTime.fromMillisecondsSinceEpoch(int.parse(dataString) * 10);
    return date;
  }

  Future<String> _readTitle(MifareUltralight mifare) async {
    final part1 = await _readBlock(tag: mifare, block: titleBlock1);
    final part2 = await _readBlock(tag: mifare, block: titleBlock2);
    return part1 + part2;
  }

  Future<String> _readId(NfcTag tag) async {
    return tag.data['mifareultralight']['identifier'].toString();
  }

  Future<String> _readBlock(
      {required MifareUltralight tag, required int block}) async {
    try {
      final data = await tag.readPages(pageOffset: block * 4);
      final convertedData = data.toList();
      convertedData.removeWhere((element) {
        return element == 0;
      });
      //TODO try authentication with transceive
      /**
       * byte[] result1 = mifare.transceive(new byte[] {
            (byte)0xA1,  /* CMD = AUTHENTICATE */
            (byte)0x00
});
       */
      // tag.transceive(data: data)
      final dataString =
          String.fromCharCodes(Uint8List.fromList(convertedData));
      print('DATA READ IN BLOCK $block: $dataString');
      return dataString.trim();
    } catch (e) {
      print(e);
      if (e is PlatformException) {
        print(e.details);
      }
      throw (e);
    }
  }

  Future<void> _writeBlock(
      {required MifareUltralight tag,
      required int block,
      required String dataString}) async {
    List<int> data = List<int>.generate(20, (index) {
      if (dataString.codeUnits.length > index) {
        return dataString.codeUnits[index];
      }
      return 0;
    });
    await tag.writePage(
        pageOffset: block * 4,
        data: Uint8List.fromList(data.getRange(0, 4).toList()));
    await tag.writePage(
        pageOffset: block * 4 + 1,
        data: Uint8List.fromList(data.getRange(4, 8).toList()));
    await tag.writePage(
        pageOffset: block * 4 + 2,
        data: Uint8List.fromList(data.getRange(8, 12).toList()));
    await tag.writePage(
        pageOffset: block * 4 + 3,
        data: Uint8List.fromList(data.getRange(12, 16).toList()));
    await tag.writePage(
        pageOffset: block * 4 + 3,
        data: Uint8List.fromList(data.getRange(16, 20).toList()));

    print("DATA SAVED IN BLOCK $block | DATA SAVED : $dataString");
    await _readBlock(block: block, tag: tag);
  }
}
