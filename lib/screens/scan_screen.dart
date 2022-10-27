import 'package:app_4/models/event_tag.dart';
import 'package:app_4/services/nfc_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/colors.dart';
import 'auth_screen.dart';

bool _checkTagValidity(DateTime startDate, DateTime lastDate) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return startDate.isBefore(today) && lastDate.isAfter(today) ||
      startDate.isBefore(today) && lastDate.isAtSameMomentAs(today) ||
      startDate.isAtSameMomentAs(today) && lastDate.isAfter(today) ||
      startDate.isAtSameMomentAs(today) && lastDate.isAtSameMomentAs(today);
}

class ScanScreen extends ConsumerWidget {
  const ScanScreen({super.key});
  static const routeName = 'scan';
  final String title = 'Festival Mais Solidário';
  final String deviceModel = 'L2 #14';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(nfcProvider.notifier).readTag().catchError((e) {
      print(e.toString());
    });
    final eventTag = ref.watch(nfcProvider)?.tag;
    final nfcError = ref.watch(nfcProvider)?.error;

    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('APP 4'),
              Text('CONTROLO DE ACESSOS'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacementNamed(context, AuthScreen.routeName);
              },
            )
          ]),
      body: Container(
        decoration: const BoxDecoration(gradient: backGradient),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 30.0),
                child: MultiCircleContainer(
                  child: Column(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.normal),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        deviceModel,
                        style: const TextStyle(
                            color: backColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 27),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Pode aproximar.',
                    style: TextStyle(fontSize: 31),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Image.asset('assets/images/scan.png'),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
            if (eventTag != null)
              GestureDetector(
                onTap: (() {
                  print("TAP");
                  ref.read(nfcProvider.notifier).reset();
                }),
                child: ValidationMessage(eventTag: eventTag!),
              ),
            if (nfcError != null)
              GestureDetector(
                onTap: (() {
                  print("TAP");
                  ref.read(nfcProvider.notifier).reset();
                }),
                child: Center(child: Text(nfcError)),
              ),
          ],
        ),
      ),
    );
  }
}

class MultiCircleContainer extends StatelessWidget {
  const MultiCircleContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    const largestSize = 400.0;
    const spacement = 150.0;
    // const scaleSecondCircle = largestSize - (largestSize / spacement) * 100;
    const scaleSecondCircle = largestSize - spacement;
    print('Scale: $scaleSecondCircle');
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            width: largestSize,
            height: largestSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          Container(
            width: largestSize - spacement,
            height: largestSize - spacement,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          Container(
            width: largestSize - (spacement + 50),
            height: largestSize - (spacement + 50),
            child: FittedBox(fit: BoxFit.scaleDown, child: child),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.3),
            ),
          )
        ],
      ),
    );
    /*  return Stack(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: fadeColor3),
      ),
      Container(
        width: MediaQuery.of(context).size.width - 17,
        height: MediaQuery.of(context).size.width - 17,
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: fadeColor2),
      ),
      Center(
        child: Container(
          width: MediaQuery.of(context).size.width - 17 * 2,
          height: MediaQuery.of(context).size.width - 17 * 2,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
          child: child,
        ),
      ),
    ]); */
  }
}

class ValidationMessage extends StatelessWidget {
  const ValidationMessage({
    Key? key,
    required this.eventTag,
  }) : super(key: key);

  final EventTag eventTag;

  @override
  Widget build(BuildContext context) {
    final availability =
        _checkTagValidity(eventTag.startDate, eventTag.endDate);
    final durationDays = eventTag.endDate.day - eventTag.startDate.day + 1;
    final validationText = availability ? 'VÁLIDO' : 'INVÁLIDO';
    final durationText = 'Bilhate Passe $durationDays Dias';
    final datesInfoText = 'Das ${eventTag.startDate.hour}h do dia ' +
        '${eventTag.startDate.day}-${eventTag.startDate.month}-${eventTag.startDate.year}, ' +
        'até ${eventTag.startDate.hour}h do dia ' +
        '${eventTag.endDate.day}-${eventTag.endDate.month}-${eventTag.endDate.year}';
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width -
            MediaQuery.of(context).size.width / 8,
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              validationText,
              style: TextStyle(color: Colors.black, fontSize: 40),
            ),
            Text(
              durationText,
              style: TextStyle(color: Colors.grey, fontSize: 23),
            ),
            Text(
              datesInfoText,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.grey),
                      height: 80,
                      width: 80,
                    ),
                    Text(
                      'Bilhete',
                      style: TextStyle(fontSize: 17, color: Colors.black54),
                    )
                  ],
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.grey),
                      height: 80,
                      width: 80,
                    ),
                    Text(
                      'Bilhete',
                      style: TextStyle(fontSize: 17, color: Colors.black54),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
