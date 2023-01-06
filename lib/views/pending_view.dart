import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:intl/intl.dart";

import '../screens/splash_screen.dart';
import '../services/offline_service.dart';

class PendingView extends StatefulWidget {
  const PendingView({super.key});
  static const name = 'pending';

  @override
  State<PendingView> createState() => _PendingViewState();
}

class _PendingViewState extends State<PendingView> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: FutureBuilder<List<Map<String, Object?>>>(
          future: OfflineService.instance.getPending(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data!.isEmpty) {
                return const Text('Sem data pendente.');
              }
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => ListTile(
                        title: Column(
                          children: [
                            Text(
                                "ID: ${snapshot.data![index]['id_bilhete'].toString()}"),
                            Text(
                                "Data de Entrada: ${DateFormat("dd-MM-yyyy").format(DateTime.parse(
                              snapshot.data![index]['entrance'].toString(),
                            ))}")
                          ],
                        ),
                      ));
            }
            return const SplashScreen();
          }),
    );
  }

  Future<void> _pullRefresh() async {
    setState(() {});
  }
}
