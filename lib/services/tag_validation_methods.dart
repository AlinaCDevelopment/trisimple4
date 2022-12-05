import 'package:app_4/services/internal_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/wifi_verification.dart';
import '../models/event_tag.dart';
import '../providers/auth_provider.dart';
import '../widgets/ui/dialog_messages.dart';

Future<void> validateTag(BuildContext context,
    {required EventTag tag, required WidgetRef ref}) async {
  Widget dialog;
  bool success = true;
  String validationMessage;
  if (tag!.eventID != ref.read(authProvider).evento!.id) {
    validationMessage = 'A Tag não pertence ao evento';
    success = false;
  } else {
    success = validateTagDates(tag!.startDate, tag!.endDate);
    validationMessage = 'Das ${tag!.startDate.hour}h do dia ' +
        '${tag!.startDate.day}-${tag!.startDate.month}-${tag!.startDate.year}, ' +
        'até ${tag!.startDate.hour}h do dia ' +
        '${tag!.endDate.day}-${tag!.endDate.month}-${tag!.endDate.year}';
  }

  dialog = ScanValidationMessage(
    eventTag: tag!,
    availability: success,
    message: validationMessage,
  );
  if (success) {
    final internet = await checkWifi();
    if (internet) {
      //TODO Send to database that this was used
    } else {
      ref.read(internalDataProvider.notifier).storeData(1);
    }
  }

  FlutterBeep.beep(success);
  showMessageDialog(context, dialog);
}

bool validateTagDates(DateTime startDate, DateTime lastDate) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day, now.hour, now.minute);
  return startDate.isBefore(today) && lastDate.isAfter(today) ||
      startDate.isBefore(today) && lastDate.isAtSameMomentAs(today) ||
      startDate.isAtSameMomentAs(today) && lastDate.isAfter(today) ||
      startDate.isAtSameMomentAs(today) && lastDate.isAtSameMomentAs(today);
}
