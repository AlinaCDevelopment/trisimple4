import '../screens/container_screen.dart';
import '../services/internal_storage_service.dart';
import '../views/search_view.dart';
import '../widgets/themed_button.dart';
import 'package:flutter_beep/flutter_beep.dart';
import '../providers/nfc_provider.dart';
import 'package:flutter/material.dart';

import '../services/translation_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/assets_routes.dart';
import '../constants/colors.dart';
import '../widgets/ui/dialog_messages.dart';

class ScanView extends ConsumerWidget {
  static const name = 'scan';

  const ScanView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          if ((snapshot.data!)) {
            ref.read(nfcProvider.notifier).readTagInSession();
            bodyPresented = Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Expanded(child: ScranImage()),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60.0, vertical: 10),
                    child: ThemedButton(
                        onTap: () => ref.read(viewProvider.notifier).state =
                            SearchView.name,
                        text: MultiLang.texts.search)),
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
                            text: MultiLang.texts.search)),
                  ],
                ));
             */
          } else {
            bodyPresented = Center(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: Text(
                MultiLang.texts.unavailableNfc,
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
                MultiLang.texts.approachNfc,
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
