import 'dart:ui';

import '../screens/container_screen.dart';
import '../services/internal_storage_service.dart';
import '../views/search_view.dart';
import '../widgets/themed_button.dart';
import '../widgets/ui/views_container.dart';
import 'package:flutter_beep/flutter_beep.dart';

import '../helpers/size_helper.dart';
import '../providers/auth_provider.dart';
import '../providers/nfc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/assets_routes.dart';
import '../constants/colors.dart';
import '../widgets/ui/dialog_messages.dart';

class ScanView extends ConsumerWidget {
  static const name = 'scan';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final equipamento = ref.read(authProvider).equipamento;
    final evento = ref.read(authProvider).evento;

    ref.listen(nfcProvider, (previous, next) async {
      if (next != null && next.error != null ||
          next != null && next.tag != null) {
        Widget dialog;
        bool success;
        if (next.error != null && next.error!.isNotEmpty) {
          dialog = ScanErrorMessage();
          success = false;
        } else {
          success = checkTagValidity(next.tag!.startDate, next.tag!.endDate);
          dialog = ScanValidationMessage(
            context,
            eventTag: next.tag!,
            availability: success,
          );
          ref.read(internalDataProvider.notifier).storeData(1);
        }
        FlutterBeep.beep(success);
        await showMessageDialog(context, dialog);
      }
    });

    return FutureBuilder(
      future: ref.read(nfcProvider.notifier).isNfcAvailable(),
      builder: (context, snapshot) {
        Widget? bodyPresented;
        if (snapshot.hasData && snapshot.data != null) {
          //REAL VERSION
          // /*
          ref.read(nfcProvider.notifier).readTag();
          if ((snapshot.data!)) {
            bodyPresented = Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: const ScranImage()),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60.0, vertical: 10),
                    child: ThemedButton(
                        onTap: () => ref.read(viewProvider.notifier).state =
                            SearchView.name,
                        text: AppLocalizations.of(context).search)),
              ],
            );
            //    */
            //TEST VERSION
            /*
          if ((true)) {
            bodyPresented = GestureDetector(
                onTap: () {
                  ref.read(nfcProvider.notifier).setDumbPositive();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(child: const ScranImage()),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60.0, vertical: 10),
                        child: ThemedButton(
                            onTap: () => ref.read(viewProvider.notifier).state =
                                SearchView.name,
                            text: AppLocalizations.of(context).search)),
                  ],
                ));
             */
          } else {
            bodyPresented = Center(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: Text(
                AppLocalizations.of(context).unavailableNfc,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    shadows: [
                      Shadow(offset: Offset(1, 1)),
                      Shadow(offset: Offset(1, -1))
                    ]),
              ),
            ));
          }
        }
        return bodyPresented ?? Container();
      },
    );
  }
}

class ScranImage extends StatelessWidget {
  const ScranImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Center(child: Image.asset(overlayCirlcedImgRoute)),
      Center(
        child: Padding(
          padding: const EdgeInsets.all(49.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Image.asset(scanImgRoute),
              Text(
                AppLocalizations.of(context).approachNfc,
                style: const TextStyle(fontSize: 22, color: backMaterialColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
