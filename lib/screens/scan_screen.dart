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
          title: const Text(
            'APP 4 - L2 #12',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacementNamed(context, AuthScreen.routeName);
              },
            )
          ]),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                children: [
                  const Text(
                    'Controlo de Acessos',
                    style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 29),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 19),
                    textAlign: TextAlign.center,
                  ),
                ],
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
                print("DATA_INICIOOOOO" + eventTag.startDate.toString());
                print("DATA_FIMMMMMMMM" + eventTag.endDate.toString());
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
    );
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
    final messageText = availability ? 'Bilhete válido' : 'Bilhete inválido';
    return Center(
      child: Container(
        height: 300,
        width: 300,
        decoration: BoxDecoration(color: Colors.black),
        child: Text(messageText),
      ),
    );
  }
}
