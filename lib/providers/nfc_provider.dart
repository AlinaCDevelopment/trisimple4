import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

import '../constants/nfc_blocks.dart';
import '../models/event_tag.dart';
import '../services/l10n/app_localizations.dart';

@immutable
class NfcState {
  final EventTag? tag;
  final String? error;

  const NfcState({this.tag, this.error});
}

@immutable
class NfcNotifier extends StateNotifier<NfcState> {
  NfcNotifier() : super(const NfcState());

  Future<void> inSession(BuildContext context,
      {required Future<void> Function(NfcTag nfcTag, MifareUltralight mifareTag)
          onDiscovered}) async {
    await NfcManager.instance.startSession(
      onDiscovered: (tag) async {
        try {
          final mifare = MifareUltralight.from(tag);
          if (mifare != null) {
            await onDiscovered(tag, mifare);
          } else {
            state = NfcState(error: ("A sua tag não é suportada!"));
          }
        } on PlatformException catch (platformException) {
          if (platformException.message == 'Tag was lost.') {
            state = NfcState(error: (AppLocalizations.of(context).tagLost));
          } else {
            state =
                NfcState(error: (AppLocalizations.of(context).platformError));
          }
        } catch (e) {
          state = NfcState(error: (AppLocalizations.of(context).processError));
        }
      },
    );
  }

  //==================================================================================================================
  //MAIN METHODS
  Future<void> readTag({
    required MifareUltralight mifareTag,
    required NfcTag nfcTag,
  }) async {
    final startDate = await _readDateTime(mifareTag, startDateBlock);
    final endDate = await _readDateTime(mifareTag, lastDateBlock);
    final id = await _readId(nfcTag);
    final eventId = await _readBlock(block: eventIdBlock, tag: mifareTag);

    state = NfcState(
        tag: EventTag(id, eventId, startDate: startDate, endDate: endDate));
  }

  Future<bool> isNfcAvailable() async {
    return await NfcManager.instance.isAvailable();
  }

  void reset() {
    state = NfcState();
  }

  //==================================================================================================================
  //QUICK METHODS

  Future<void> readTagInSession(BuildContext context) async {
    await inSession(context, onDiscovered: (nfcTag, mifareTag) async {
      await readTag(mifareTag: mifareTag, nfcTag: nfcTag);
    });
  }

  //==================================================================================================================
  //PRIVATE METHODS

  Future<DateTime> _readDateTime(MifareUltralight mifare, int block) async {
    final dataString = await _readBlock(tag: mifare, block: block);
    print(int.parse(dataString));
    //Multiply by 10 because we're losing a 0 when reading
    var date = DateTime.fromMillisecondsSinceEpoch(int.parse(dataString) * 10);
    return date;
  }

  Future<String> _readId(NfcTag tag) async {
    return tag.data['mifareultralight']['identifier'].toString();
  }

  Future<String> _readBlock(
      {required MifareUltralight tag, required int block}) async {
    final data = await tag.readPages(pageOffset: block * 4);
    final convertedData = data.toList();
    convertedData.removeWhere((element) {
      return element == 0;
    });
    final dataString = String.fromCharCodes(Uint8List.fromList(convertedData));
    print('DATA READ IN BLOCK $block: $dataString');
    return dataString.trim();
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

final nfcProvider = StateNotifierProvider<NfcNotifier, NfcState?>((ref) {
  return NfcNotifier();
});
