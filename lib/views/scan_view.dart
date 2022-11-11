import 'dart:ui';

import 'package:app_4/widgets/themed_button.dart';
import 'package:app_4/widgets/ui/views_container.dart';

import '../helpers/size_helper.dart';
import '../providers/auth_provider.dart';
import '../providers/nfc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/assets_routes.dart';
import '../constants/colors.dart';
import '../widgets/ui/dialog_messages.dart';

//TODO Resize icon to not take as much space
//TODO Fix authentication preferences save

class ScanView extends ConsumerWidget {
  const ScanView(this.parentContext, {super.key});
  final BuildContext parentContext;

  static const name = 'scan';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final equipamento = ref.read(authProvider).equipamento;
    final evento = ref.read(authProvider).evento;

    ref.listen(nfcProvider, (previous, next) {
      if (next != null && next.error != null ||
          next != null && next.tag != null) {
        Widget dialog;
        if (next.error != null && next.error!.isNotEmpty) {
          dialog = ErrorMessage(parentContext);
        } else {
          dialog = ValidationMessage(parentContext, eventTag: next.tag!);
        }
        showDialog(
          context: context,
          barrierColor: Colors.transparent,
          builder: (BuildContext context) {
            return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: dialog);
          },
        );
      }
    });

    return ScanContainer(
      ref: ref,
      nfcUserChild: ScanBody(
        parentContext: parentContext,
        title: evento?.nome ?? '',
        deviceModel:
            '${equipamento?.tipoEquipamento} #${equipamento?.numeroEquipamento}',
      ),
    );
  }
}

//TODO remove ref as an argument and wrap the scanbody in a future builder instead
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
          //REAL VERSION
          //  if ((snapshot.data!)) {
          //    bodyPresented = nfcUserChild;
          //TEST VERSION
          if ((true)) {
            bodyPresented = GestureDetector(
                onTap: () {
                  ref.read(nfcProvider.notifier).setDumbPositive();
                },
                child: nfcUserChild);
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
        return bodyPresented ?? Container();
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
    return ThemedButton(
        onTap: () {}, text: AppLocalizations.of(context).search);
  }
}

class ScanBody extends StatelessWidget {
  const ScanBody({
    Key? key,
    required this.parentContext,
    required this.title,
    required this.deviceModel,
  }) : super(key: key);

  final BuildContext parentContext;
  final String title;
  final String deviceModel;

  @override
  Widget build(BuildContext context) {
    //  ref.read(nfcProvider.notifier).readTag().catchError((e) {
    //    print(e.toString());
    //  });
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ScranImage(),
        const Padding(
          padding: EdgeInsets.only(right: 60.0, left: 60.0, bottom: 10),
          child: SearchButton(),
        ),
      ],
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
