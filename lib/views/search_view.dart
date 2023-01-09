// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:app_4/helpers/wifi_verification.dart';
import 'package:app_4/providers/auth_provider.dart';
import 'package:app_4/services/database_service.dart';
import 'package:app_4/services/tag_validation_methods.dart';
import 'package:app_4/widgets/ui/dialog_messages.dart';

import '../helpers/size_helper.dart';
import '../services/l10n/app_localizations.dart';
import '../widgets/themed_button.dart';
import '../widgets/themed_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchView extends ConsumerWidget {
  SearchView({super.key});
  static const name = 'search';
  String text = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 30.0, vertical: SizeConfig.screenHeight * 0.06),
      child: Column(
        children: [
          Text(AppLocalizations.of(context).codeInsertLabel),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ThemedInput(
                onChanged: (value) => text = value,
                hintText: AppLocalizations.of(context).codeInsertLabel),
          ),
          ThemedButton(
              onTap: () async {
                try {
                  final hasWifi = await checkWifiWithValidation(context);
                  if (hasWifi) {
                    try {
                      final tag = await DatabaseService.instance
                          .getTicketByPhysicalId(text.trim());
                      if (tag == null) {
                        showMessageDialog(
                            context,
                            MessageDialog(
                                title: AppLocalizations.of(context).invalid,
                                content: AppLocalizations.of(context)
                                    .ticketIsNotFromEvent(
                                        ref.read(authProvider).evento!.nome)));
                      } else {
                        validateTagAndSendData(context, tag: tag, ref: ref);
                      }
                    } on SocketException {
                      print('wifi interrupted');
                    }
                  }
                } catch (e) {
                  showMessageDialog(
                      context,
                      MessageDialog(
                        title: '',
                        content: 'Error',
                      ));
                }
              },
              text: AppLocalizations.of(context).search)
        ],
      ),
    );
  }
}
