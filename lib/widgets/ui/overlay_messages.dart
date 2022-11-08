import 'package:app_4/constants/assets_routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../models/event_tag.dart';

class ErrorMessage extends StatelessWidget {
  ErrorMessage(this.parentContext);
  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    return OverlayMessage(
        context: parentContext,
        title: AppLocalizations.of(context)!.error,
        assetPngImgName: 'error');
  }
}

class ValidationMessage extends StatelessWidget {
  const ValidationMessage(
    this.parentContext, {
    Key? key,
    required this.eventTag,
  }) : super(key: key);

  final EventTag eventTag;
  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    final availability =
        _checkTagValidity(eventTag.startDate, eventTag.endDate);
    final durationDays = eventTag.endDate.day - eventTag.startDate.day + 1;
    //TODO Localize validationText
    final validationText = availability
        ? AppLocalizations.of(context)!.valid
        : AppLocalizations.of(context)!.invalid;
    String durationText;

    if (eventTag.endDate.difference(eventTag.startDate).inDays > 0) {
      durationText = 'Bilhete Passe $durationDays Dias';
    } else {
      durationText =
          'Bilhete Diário ${eventTag.startDate.day} ${_getMonth(eventTag.startDate.month)} ${eventTag.startDate.year}';
    }
    final datesInfoText = 'Das ${eventTag.startDate.hour}h do dia ' +
        '${eventTag.startDate.day}-${eventTag.startDate.month}-${eventTag.startDate.year}, ' +
        'até ${eventTag.startDate.hour}h do dia ' +
        '${eventTag.endDate.day}-${eventTag.endDate.month}-${eventTag.endDate.year}';
    return OverlayMessage(
      assetPngImgName: availability ? validImgRoute : invalidImgRoute,
      context: parentContext,
      title: validationText,
      content: Column(children: [
        Column(
          children: [
            Text(
              durationText,
              style: const TextStyle(color: Colors.grey, fontSize: 23),
            ),
            Text(
              datesInfoText,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: QrImage(
                    data: "1234567890",
                    version: QrVersions.auto,
                    //size: 200.0,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.ticket,
                  style: const TextStyle(fontSize: 17, color: Colors.black54),
                )
              ],
            ),
            Column(
              children: [
                Container(
                  decoration: const BoxDecoration(color: Colors.grey),
                  height: 80,
                  width: 80,
                ),
                Text(
                  AppLocalizations.of(context)!.bracelet,
                  style: const TextStyle(fontSize: 17, color: Colors.black54),
                )
              ],
            )
          ],
        )
      ]),
    );
  }
}

bool _checkTagValidity(DateTime startDate, DateTime lastDate) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  //TODO INCLUDE HOUR AND MINUTES
  return startDate.isBefore(today) && lastDate.isAfter(today) ||
      startDate.isBefore(today) && lastDate.isAtSameMomentAs(today) ||
      startDate.isAtSameMomentAs(today) && lastDate.isAfter(today) ||
      startDate.isAtSameMomentAs(today) && lastDate.isAtSameMomentAs(today);
}

//TODO REMOVE THIS WHEN DB IS READY
String _getMonth(int month) {
  switch (month) {
    case 1:
      return 'Janeiro';
    case 2:
      return 'Fevereiro';
    case 3:
      return 'Março';
    case 4:
      return 'Abril';
    case 5:
      return 'Maio';
    case 6:
      return 'Junho';
    case 7:
      return 'Julho';
    case 8:
      return 'Agosto';
    case 9:
      return 'Setembro';
    case 10:
      return 'Outubro';
    case 11:
      return 'Novembro';
    default:
      return 'Dezembro';
  }
}

class OverlayMessage extends StatelessWidget {
  const OverlayMessage(
      {super.key,
      required this.context,
      required this.title,
      this.content,
      required this.assetPngImgName});
  final BuildContext context;
  final String title;
  final Widget? content;
  final String assetPngImgName;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width -
                MediaQuery.of(context).size.width / 8,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 100.0, left: 100.0, top: 50),
                    child: Image.asset(assetPngImgName),
                  ),
                  Text(
                    title,
                    style: const TextStyle(color: Colors.black, fontSize: 40),
                  ),
                  content ?? Container()
                ])));
  }
}
