import '../../helpers/size_helper.dart';
import '../../providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/assets_routes.dart';
import '../../constants/colors.dart';
import '../../constants/decorations.dart';
import '../../services/l10n/app_localizations.dart';

class ViewContainer extends ConsumerWidget {
  const ViewContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: backgroundDecoration,
      //May need to be deleted TODO test with Nfc device
      constraints: const BoxConstraints.expand(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Column(
              children: [
                Text(
                  ref.read(authProvider).evento!.nome,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${ref.read(authProvider).equipamento!.tipo} #${ref.read(authProvider).equipamento!.numeroEquipamento}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
              child: child,
            ),
          ),
          FittedBox(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: SizeConfig.screenHeight * 0.09),
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 70.0),
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.contactsLabel,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13),
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
                        )),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.05,
                    ),
                    Center(
                      child: Text(
                        '${AppLocalizations.of(context).version}: 1.0.0',
                        style: TextStyle(fontSize: 11, color: thirdColor),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
