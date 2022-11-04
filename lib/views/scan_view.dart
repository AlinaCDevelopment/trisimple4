import 'package:app_4/providers/auth_service.dart';
import 'package:app_4/providers/nfc_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/colors.dart';
import '../widgets/ui/overlay_messages.dart';

class ScanView extends ConsumerWidget {
  const ScanView(this.parentContext, {super.key});
  final BuildContext parentContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final equipamento = ref.read(authProvider).equipamento;
    final evento = ref.read(authProvider).evento;
    return ScanContainer(
      ref: ref,
      nfcUserChild: ScanBody(
        ref: ref,
        parentContext: parentContext,
        title: evento?.nome ?? '',
        deviceModel:
            '${equipamento?.tipoEquipamento}#${equipamento?.numeroEquipamento}',
      ),
    );
  }
}

class ScanContainer extends StatelessWidget {
  const ScanContainer(
      {super.key, required this.ref, required this.nfcUserChild});

  final WidgetRef ref;
  final Widget nfcUserChild;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ref.read(nfcProvider.notifier).isNfcAvailable(),
      builder: (context, snapshot) {
        Widget? bodyPresented;
        if (snapshot.hasData && snapshot.data != null) {
          if ((snapshot.data!)) {
            bodyPresented = nfcUserChild;
          } else {
            bodyPresented = Center(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: Text(
                AppLocalizations.of(context)!.unavailableNfc,
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
        return Container(
          decoration: const BoxDecoration(gradient: backGradient),
          child: bodyPresented,
          //May need to be deleted TODO test with Nfc device
          constraints: const BoxConstraints.expand(),
        );
      },
    );
  }
}

class SearchButton extends StatelessWidget {
  const SearchButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
          height: 48,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              color: backMaterialColor),
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.search,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          )),
    );
  }
}

class ScanBody extends StatelessWidget {
  const ScanBody({
    Key? key,
    required this.parentContext,
    required this.ref,
    required this.title,
    required this.deviceModel,
  }) : super(key: key);

  final BuildContext parentContext;
  final WidgetRef ref;
  final String title;
  final String deviceModel;

  @override
  Widget build(BuildContext context) {
    ref.read(nfcProvider.notifier).readTag().catchError((e) {
      print(e.toString());
    });
    final nfcNotifier = ref.watch(nfcProvider);
    final eventTag = nfcNotifier?.tag;
    final nfcError = nfcNotifier?.error;

    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    deviceModel,
                    style: const TextStyle(
                        color: backMaterialColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 30.0),
                child: Stack(children: [
                  Center(
                      child: Image.asset('assets/images/overlayCircles.png')),
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
                          Image.asset('assets/images/scan.png'),
                          Text(
                            AppLocalizations.of(context)!.approachNfc,
                            style: const TextStyle(
                                fontSize: 22, color: backMaterialColor),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 60.0, left: 60.0, bottom: 10),
                  child: SearchButton(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 70.0),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.contactsLabel,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: backMaterialColor, fontSize: 13),
                      ),
                      const Text(
                        '+351 962 260 499',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 150,
            )
          ],
        ),
        if (eventTag != null)
          GestureDetector(
            onTap: (() {
              ref.read(nfcProvider.notifier).reset();
            }),
            child: ValidationMessage(parentContext, eventTag: eventTag!),
          ),
        if (nfcError != null)
          GestureDetector(
            onTap: (() {
              ref.read(nfcProvider.notifier).reset();
            }),
            child: ErrorMessage(parentContext),
          ),
      ],
    );
  }
}
