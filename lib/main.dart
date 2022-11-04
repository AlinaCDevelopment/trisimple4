import 'dart:io';
import 'package:app_4/screens/splash_screen.dart';
import 'package:app_4/services/database_service.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app_4/screens/container_screen.dart';
import 'package:app_4/providers/auth_service.dart';
import 'package:app_4/views/scan_view.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:upgrader/upgrader.dart';

import 'constants/colors.dart';
import 'providers/locale_provider.dart';
import 'screens/auth_screen.dart';

//TODO Set at start the screen size instead of using media queries everywhere
//TODO Fix localizations with iOS: https://www.codeandweb.com/babeledit/tutorials/how-to-translate-your-flutter-apps
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
      overlays: []);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});
  var _prefsRead = false;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //  var isConnectedToWifi = false;

    //ref.read(localeProvider.notifier).getLocaleFromPrefs();
    final locale = ref.watch(localeProvider);
    if (locale == null) {
      _prefsRead = true;
      ref.read(localeProvider.notifier).getLocaleFromPrefs();
    }
    //print('wifi connect: $isConnectedToWifi');

    return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        debugShowCheckedModeBanner: false,
        title: 'Trisimple 4',
        theme: ThemeData(
            fontFamily: 'Ubuntu',
            brightness: Brightness.dark,
            primarySwatch: brightMaterialColor,
            scaffoldBackgroundColor: backMaterialColor,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: Border(bottom: BorderSide(color: secondColor, width: 1)),
            ),
            backgroundColor: backMaterialColor,
            canvasColor: Colors.white,
            hintColor: hintColor,
            iconTheme: const IconThemeData(color: backMaterialColor)),
        //themeMode: ThemeMode.dark,
        home: FutureBuilder<ConnectivityResult>(
            future: Connectivity().checkConnectivity(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final isConnectedToWifi =
                    snapshot.data == ConnectivityResult.wifi;
                return isConnectedToWifi
                    ? UpgradeAlert(
                        upgrader: Upgrader(
                            durationUntilAlertAgain: Duration(seconds: 0),
                            // durationUntilAlertAgain: const Duration(hours: 8),
                            // canDismissDialog: false,
                            canDismissDialog: false,
                            showIgnore: false,
                            showLater: false,
                            languageCode: locale.languageCode,
                            dialogStyle: Platform.isIOS
                                ? UpgradeDialogStyle.cupertino
                                : UpgradeDialogStyle.material),
                        child: _buildHome(ref),
                      )
                    : _buildHome(ref);
              }
              return Container();
            }));
  }

  FutureBuilder<bool> _buildHome(WidgetRef ref) {
    final auth = ref.read(authProvider);
    return FutureBuilder<bool>(
        future: ref.read(authProvider.notifier).authenticateFromPreviousLogs(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data!) {
              return ContainerScreen(title: auth.evento!.nome);
            } else {
              return const AuthScreen();
            }
          }
          return const SplashScreen();
        });
  }
}
