import 'package:app_4/services/database_service.dart';
import 'package:app_4/services/internal_storage_service.dart';
import 'package:app_4/services/offline_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/wifi_verification.dart';
import '../models/event_tag.dart';
import '../providers/auth_provider.dart';
import '../widgets/ui/dialog_messages.dart';

/* Future<void> validateTag(BuildContext context,
    {required Bilhete tag, required WidgetRef ref}) async {
  try {
    await _validateTag(context, bilhete: tag, ref: ref);
  } on SocketException {
    final evento = ref.read(authProvider).evento!;

    final hasWifi = await checkWifi();
    DatabaseService.instance
        .setDataSource(isConnected: hasWifi, idEvento: evento.id);

    await _validateTag(context, bilhete: tag, ref: ref);
  }
}

Future<void> _validateTag(BuildContext context,
    {required Bilhete bilhete, required WidgetRef ref}) async {
  String? validMessage;
  bool valid = true;
  final evento = ref.read(authProvider).evento!;

  final now = DateTime.now();
  if (bilhete.data_inicio != null && bilhete.data_fim != null) {
    final startDate = bilhete.data_inicio!;
    final startDateFormatted = DateFormat('dd/MM/yy').format(startDate);
    final endDate = bilhete.data_fim!;
    final endDateFormatted = DateFormat('dd/MM/yy').format(endDate);
    if (bilhete.data_inicio!.isBefore(now)) {
      if (bilhete.data_fim!.isBefore(now)) {
        validMessage =
            AppLocalizations.of(context).ticketExpired(endDateFormatted);
        valid = false;
      } else {
        validMessage = AppLocalizations.of(context).ticketDateSpan(
            startDate.hour, startDateFormatted, endDate.hour, endDateFormatted);
      }
    } else {
      validMessage =
          AppLocalizations.of(context).cantBeUsedYet(startDateFormatted);
      valid = false;
    }
  }
  if (valid) {
    DatabaseService.instance.sendData('TODO');
  }

  FlutterBeep.beep(valid);
  await showMessageDialog(
      context,
      ScanValidationMessage(
        bilhete: bilhete,
        availability: valid,
        message: validMessage,
      ));
} */
Bilhete? lastTag;
DateTime? lastMomentSaved;
Future<void> validateTagAndSendData(BuildContext context,
    {required Bilhete tag, required WidgetRef ref}) async {
  Widget dialog;
  bool tagIsValid = true;
  String validationMessage;
  //if (tag!.eventID != ref.read(authProvider).evento!.id) {
  //  validationMessage = 'A Tag não pertence ao evento';
  //  success = false;
  //} else {
  tagIsValid = validateTagDates(tag!.startDate, tag!.endDate);
  validationMessage = 'Das ${tag!.startDate.hour}h do dia ' +
      '${tag!.startDate.day}-${tag!.startDate.month}-${tag!.startDate.year}, ' +
      'até ${tag!.startDate.hour}h do dia ' +
      '${tag!.endDate.day}-${tag!.endDate.month}-${tag!.endDate.year}';
  //}

  dialog = ScanValidationMessage(
    eventTag: tag,
    availability: tagIsValid,
    message: validationMessage,
  );
  if (tagIsValid) {
    //If the last scanned tag is this now scanned tag, send data
    var now = DateTime.now();
    now = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    print('same as last? : ${lastTag == tag}');
    if (lastTag != tag) {
      await _sendEntrance(tag: tag, ref: ref, moment: now);
    } else {
      //If it is the same tag, but the last moment was different, send data
      if (lastMomentSaved != null) {
        print(
            'Last moment saved is before now? : ${lastMomentSaved!.isBefore(now) == true}');
        if (lastMomentSaved!.isBefore(now) == true) {
          await _sendEntrance(tag: tag, ref: ref, moment: now);
        }
      } else {
        await _sendEntrance(tag: tag, ref: ref, moment: now);
      }
    }
    lastTag = tag;
    now = DateTime.now();
    final addedMinute = now.second > 29 ? 1 : 0;
    lastMomentSaved = DateTime(
        now.year, now.month, now.day, now.hour, now.minute + addedMinute);
  }

  FlutterBeep.beep(tagIsValid);
  showMessageDialog(context, dialog);
}

Future<void> _sendEntrance(
    {required Bilhete tag,
    required WidgetRef ref,
    required DateTime moment}) async {
  print('moment sent: ${moment.second}');
  final internet = await checkWifi();
  if (internet) {
    try {
      final datasent =
          await DatabaseService.instance.sendEntrance(tag.ticketId, moment);
      if (!datasent) {
        throw ('data not sent');
      }
    } catch (_) {
      OfflineService.instance.setPending(tag.ticketId, moment);
      ref.read(pendingCounter.notifier).increment(1);
    }
  } else {
    OfflineService.instance.setPending(tag.ticketId, moment);
    ref.read(pendingCounter.notifier).increment(1);
  }
}

bool validateTagDates(DateTime startDate, DateTime lastDate) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day, now.hour, now.minute);
  return startDate.isBefore(today) && lastDate.isAfter(today) ||
      startDate.isBefore(today) && lastDate.isAtSameMomentAs(today) ||
      startDate.isAtSameMomentAs(today) && lastDate.isAfter(today) ||
      startDate.isAtSameMomentAs(today) && lastDate.isAtSameMomentAs(today);
}
