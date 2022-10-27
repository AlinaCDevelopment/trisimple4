import 'package:app_4/models/event_tag.dart';
import 'package:app_4/services/nfc_service.dart';
import 'package:app_4/widgets/appDrawer.dart';
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
  final bool isPT = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(nfcProvider.notifier).readTag().catchError((e) {
      print(e.toString());
    });
    final eventTag = ref.watch(nfcProvider)?.tag;
    final nfcError = ref.watch(nfcProvider)?.error;

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'APP 4',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  'CONTROLO DE ACESSOS',
                  style: TextStyle(
                      fontSize: 12, color: Color.fromRGBO(150, 115, 250, 1)),
                ),
              ],
            ),
          ],
        ),
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: Padding(
              padding:
                  const EdgeInsets.only(left: 3.0, right: 5, top: 1, bottom: 1),
              child: Image.asset(
                  isPT ? 'assets/images/pt.png' : 'assets/images/en.png'),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, AuthScreen.routeName);
            },
          )
        ],
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/menu.png'),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        }),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: backGradient),
        child: Stack(
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
                            color: backColor,
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
                          child:
                              Image.asset('assets/images/overlayCircles.png')),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(49.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Image.asset('assets/images/scan.png'),
                              const Text(
                                'Pode aproximar.',
                                style:
                                    TextStyle(fontSize: 22, color: backColor),
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
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 60.0, left: 60.0, bottom: 10),
                      child: SearchButton(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70.0),
                      child: Column(
                        children: [
                          Text(
                            'Contato responsável técnico\n do evento para pedido de suporte:',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: backColor, fontSize: 13),
                          ),
                          Text(
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
                SizedBox(
                  height: 150,
                )
              ],
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
              padding:
                  const EdgeInsets.only(right: 100.0, left: 100.0, top: 50),
              child: FittedBox(
                fit: BoxFit.contain,
                child: availability
                    ? Image.asset('assets/images/valid.png')
                    : Image.asset('assets/images/invalid.png'),
              ),
            ),
            Text(
              validationText,
              style: TextStyle(color: Colors.black, fontSize: 40),
            ),
            Column(
              children: [
                Text(
                  durationText,
                  style: TextStyle(color: Colors.grey, fontSize: 23),
                ),
                Text(
                  datesInfoText,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
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
}

class SearchButton extends StatelessWidget {
  const SearchButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(ScanScreen.routeName);
      },
      child: Container(
          height: 48,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              color: backColor),
          child: const Center(
            child: Text(
              'Procurar',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          )),
    );
  }
}
