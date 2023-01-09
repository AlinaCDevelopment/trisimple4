import 'dart:io';

import 'package:flutter/material.dart';

import '../services/l10n/app_localizations.dart';

import '../widgets/ui/dialog_messages.dart';

Future<bool> checkWifi() async {
  try {
    final searchResult = await InternetAddress.lookup('example.com');
    return searchResult.isNotEmpty && searchResult[0].rawAddress.isNotEmpty;
  } on SocketException {
    return false;
  }
}

Future<bool> checkWifiWithValidation(BuildContext context) async {
  final isConnected = await checkWifi();
  print(isConnected);
  if (!isConnected)
    await showMessageDialog(
      context,
      MessageDialog(
        content: AppLocalizations.of(context).tryAgain,
        title: AppLocalizations.of(context).connectionError,
      ),
    );
  return isConnected;
}
