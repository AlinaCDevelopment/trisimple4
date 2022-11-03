import 'dart:io';
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
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isConnectedToWifi = false;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final connectivityResult = await (Connectivity().checkConnectivity());
      isConnectedToWifi = connectivityResult == ConnectivityResult.wifi;
    });
    final locale = ref.watch(localeProvider);

    return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        debugShowCheckedModeBanner: false,
        title: 'Trisimple 4',
        theme: ThemeData(
            fontFamily: 'Ubuntu',
            brightness: Brightness.dark,
            primarySwatch: backColor,
            scaffoldBackgroundColor: backColor,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: Border(bottom: BorderSide(color: secondColor, width: 1)),
            ),
            backgroundColor: backColor,
            canvasColor: Colors.white,
            hintColor: hintColor,
            iconTheme: const IconThemeData(color: backColor)),
        //themeMode: ThemeMode.dark,
        home: isConnectedToWifi
            ? UpgradeAlert(
                upgrader: Upgrader(
                    // durationUntilAlertAgain: const Duration(hours: 8),
                    canDismissDialog: false,
                    dialogStyle: Platform.isIOS
                        ? UpgradeDialogStyle.cupertino
                        : UpgradeDialogStyle.material),
                child: _buildHome(ref),
              )
            : _buildHome(ref)

        /*    
           FutureBuilder<bool>(
              future: isAuthenticated,
              builder: (context, snapshot) {
                return FutureBuilder<ConnectivityResult>(
                    future: Connectivity().checkConnectivity(),
                    builder: (context, snapshot) {
                      final screen = isAuthenticated
                          ? const ContainerScreen()
                          : const AuthScreen();
                      if (snapshot.data != null) {
                        if (snapshot.data == ConnectivityResult.wifi ||
                            snapshot.data == ConnectivityResult.mobile) {
                          return UpgradeAlert(
                              upgrader: Upgrader(
                                  // durationUntilAlertAgain: const Duration(hours: 8),
                                  dialogStyle: Platform.isIOS
                                      ? UpgradeDialogStyle.cupertino
                                      : UpgradeDialogStyle.material),
                              child: screen);
                        } else {
                          return screen;
                        }
                      }
                      return Container();
                    });
              }), */
        );
  }

  FutureBuilder<bool> _buildHome(WidgetRef ref) {
    final auth = ref.read(authProvider);
    return FutureBuilder<bool>(
        future: ref.read(authProvider.notifier).authenticateFromPreviousLogs(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data!) {
              return const ContainerScreen();
            } else {
              return const AuthScreen();
            }
            /*  return (snapshot.data == true)
                ? const ContainerScreen()
                : const AuthScreen(); */
          }
          return const CircularProgressIndicator();
        });
  }
}
