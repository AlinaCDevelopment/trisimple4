import 'dart:io';
import '../widgets/ui/dialog_messages.dart';
import '../helpers/size_helper.dart';
import '../screens/splash_screen.dart';

import '../screens/container_screen.dart';
import '../providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upgrader/upgrader.dart';
import 'constants/colors.dart';
import 'constants/decorations.dart';
import 'helpers/wifi_verification.dart';
import 'providers/locale_provider.dart';
import 'screens/auth_screen.dart';
import 'services/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
      overlays: []);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    bool hasWifi = false;

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
              backgroundColor: appBarColor,
              titleTextStyle: TextStyle(color: appBarTextColor),
              shadowColor: Colors.transparent,
            ),
            backgroundColor: backMaterialColor,
            canvasColor: Colors.white,
            hintColor: hintColor,
            iconTheme: const IconThemeData(color: backMaterialColor)),
        home: FutureBuilder<bool>(
            future: checkWifi(),
            builder: (context, snapshot) {
              SizeConfig.init(context);
              if (snapshot.hasData && snapshot.data != null) {
                hasWifi = snapshot.data!;
                try {
                  return hasWifi
                      ? UpgradeAlert(
                          upgrader: Upgrader(
                              canDismissDialog: false,
                              showIgnore: false,
                              showLater: false,
                              languageCode: locale.languageCode,
                              dialogStyle: Platform.isIOS
                                  ? UpgradeDialogStyle.cupertino
                                  : UpgradeDialogStyle.material),
                          child: _buildHome(ref, hasWifi),
                        )
                      : _buildHome(ref, hasWifi);
                } catch (e) {
                  //TODO LATER FIND BETTER SOLUTION
                  //If an error occurs after runnning for the first time, then don't use the upgradeAlert
                  return _buildHome(ref, hasWifi);
                }
              }
              return const SplashScreen();
            }));
  }

  Widget _buildHome(WidgetRef ref, bool hasWifi) {
    return FutureBuilder<bool>(
        future: ref.read(authProvider.notifier).authenticateFromPreviousLogs(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data!) {
              return const ContainerScreen();
            } else {
              if (hasWifi) {
                return const AuthScreen();
              } else {
                return _buildWifiErrorScreen();
              }
            }
          }
          return const SplashScreen();
        });
  }

  Widget _buildWifiErrorScreen() {
    return Scaffold(
        body: GestureDetector(
      onTap: () async {
        setState(() {});
      },
      child: Container(
        decoration: backgroundDecoration,
        child: Center(
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth * 0.10),
                child: DialogMessage(
                  hideExit: true,
                  content: AppLocalizations.of(context).connectionError,
                  title: AppLocalizations.of(context).tryAgain,
                ))),
      ),
    ));
  }
}
