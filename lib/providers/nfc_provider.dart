import 'dart:io';

import 'package:app_4/models/event_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:nfc_manager/src/nfc_manager/nfc_manager.dart';

import '../services/database_service.dart';
import '../services/l10n/app_localizations.dart';
import 'nfc_provider_base.dart';
import 'nfc_provider_classic.dart';
import 'nfc_provider_ultralight.dart';

class NfcNotifier extends NfcNotifierBase {
  Future<bool> isNfcAvailable() async {
    return await NfcManager.instance.isAvailable();
  }

  Future<void> inSession(BuildContext context,
      {required Future<void> Function(NfcTag nfcTag) onDiscovered}) async {
    await NfcManager.instance.startSession(
      onDiscovered: (tag) async {
        try {
          var isValidTagType = MifareUltralight.from(tag) != null;
          if (!isValidTagType) {
            isValidTagType = MifareClassic.from(tag) != null;
          }
          if (isValidTagType) {
            await onDiscovered(tag);
          } else {
            state =
                NfcState(error: (AppLocalizations.of(context).unsupportedTag));
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
          throw (e);
        }
      },
    );
  }

  @override
  Future<Bilhete> readTag({required NfcTag nfcTag}) async {
    dynamic mifareTag = MifareUltralight.from(nfcTag);
    if (mifareTag != null) {
      final tag = await NfcNotifierUltralight().readTag(nfcTag: nfcTag);
      state = NfcState(tag: tag);
    } else {
      final tag = await NfcNotifierClassic().readTag(nfcTag: nfcTag);
      state = NfcState(tag: tag);
    }
    return state.tag!;
  }
}

final nfcProvider = StateNotifierProvider<NfcNotifier, NfcState?>((ref) {
  return NfcNotifier();
});
