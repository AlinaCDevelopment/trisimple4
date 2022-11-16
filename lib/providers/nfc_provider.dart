import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

import '../models/event_tag.dart';

@immutable
class NfcState {
  EventTag? tag;
  String? error;

  NfcState(this.tag);
  NfcState.error(this.error);
}

@immutable
class NfcNotifier extends StateNotifier<NfcState> {
  final _startDateOffsets = [16, 17, 18];
  final _endDateOffsets = [20, 21, 22];
  final _idOffsets = [20, 21, 22];

  NfcNotifier() : super(NfcState(null));

  Future<void> readTag() async {
    await NfcManager.instance.startSession(
      onDiscovered: (tag) async {
        try {
          final mifare = MifareUltralight.from(tag);
          if (mifare != null) {
            final startDate = await _readDateTime(mifare, _startDateOffsets);
            final endDate = await _readDateTime(mifare, _endDateOffsets);
            final id = await _readId();
            final eventId = await _readEventId();

            state = NfcState(
                EventTag(id, eventId, startDate: startDate, endDate: endDate));
          } else {
            state = NfcState.error("A sua tag não é suportada!");
          }
        } on PlatformException catch (platformException) {
          if (platformException.message == 'Tag was lost.') {
            state = NfcState.error(
                "A tag foi perdida. \nMantenha a tag próxima até obter resultados.");
          } else {
            state = NfcState.error("Ocorreu um erro de plataforma.");
          }
        } catch (e) {
          state = NfcState.error("Ocorreu um erro durante a leitura.");
        }
      },
    );
  }

  Future<bool> isNfcAvailable() async {
    return await NfcManager.instance.isAvailable();
  }

  void reset() {
    state = NfcState(null);
  }

  Future<DateTime> _readDateTime(
      MifareUltralight mifare, List<int> offsets) async {
    final day = await mifare.readPages(pageOffset: offsets[0]);
    final month = await mifare.readPages(pageOffset: offsets[1]);
    final year = await mifare.readPages(pageOffset: offsets[2]);

    final date = DateTime(
      int.parse(String.fromCharCodes(year).substring(0, 4)),
      int.parse(String.fromCharCodes(month).substring(0, 4)),
      int.parse(String.fromCharCodes(day).substring(0, 4)),
    );
    return date;
  }

  Future<int> _readId() async {
    return 0;
  }

  Future<int> _readEventId() async {
    return 0;
  }

  void setDumbPositive() {
    state = NfcState(EventTag(
      0,
      0,
      endDate: DateTime.now(),
      startDate: DateTime.now(),
    ));
  }
}

final nfcProvider = StateNotifierProvider<NfcNotifier, NfcState?>((ref) {
  return NfcNotifier();
});
