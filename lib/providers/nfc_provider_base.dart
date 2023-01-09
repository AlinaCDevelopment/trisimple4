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
  final Bilhete? tag;
  final String? error;

  const NfcState({this.tag, this.error});
}

@immutable
abstract class NfcNotifierBase extends StateNotifier<NfcState> {
  NfcNotifierBase() : super(NfcState());

  Future<Bilhete> readTag({required NfcTag nfcTag});
}
