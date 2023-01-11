import 'package:app_4/services/l10n/app_localizations.dart';
import 'package:app_4/widgets/themed_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:intl/intl.dart";
import 'package:path/path.dart';
import '../../helpers/size_helper.dart';

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
                return Text(AppLocalizations.of(context).noPendingData);
              }
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: 1,
                  itemBuilder: (context, index) => ListTile(
                        title: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(70),
                              margin: EdgeInsets.only(top: 0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 15, color: Colors.white),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "4",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 80,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context).pendingText,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 70),
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.screenWidth * 0.08),
                              child: ThemedButton(
                                  onTap: () => Navigator.pop(context),
                                  text: AppLocalizations.of(context)
                                      .pendingButton),
                            ),
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
