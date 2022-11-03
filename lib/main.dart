import 'dart:io';

import 'package:app_4/screens/container_screen.dart';
import 'package:app_4/services/auth_service.dart';
import 'package:app_4/views/scan_view.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:upgrader/upgrader.dart';

import 'constants/colors.dart';
import 'screens/auth_screen.dart';

//TODO Set at start the screen size instead of using media queries everywhere
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.top]);
  await SystemChrome.setSystemUIChangeCallback(
    (systemOverlaysAreVisible) async {
      print("tghjklç");
    },
  );
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
      if (connectivityResult == ConnectivityResult.wifi) {
        print('wifi : $isConnectedToWifi');
      }
    });

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'EN'),
          Locale('pt', 'PT'),
        ],
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
                    minAppVersion: '2.0.0',
                    canDismissDialog: false,
                    countryCode: 'lu.lafiducia.la_fiducia',
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
            print('Is initialized: ${snapshot.data}');
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
