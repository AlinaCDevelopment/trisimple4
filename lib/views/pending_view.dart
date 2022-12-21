import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
              if (snapshot.data!.length == 0) {
                return Text('No pending data');
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(snapshot.data![index].toString()),
                ),
              );
            }
            return SplashScreen();
          }),
    );
  }

  Future<void> _pullRefresh() async {
    setState(() {});
  }
}
