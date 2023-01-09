import 'dart:async';
import 'dart:io';
import 'package:app_4/services/database_service.dart';
import 'package:app_4/services/internal_storage_service.dart';
import 'package:app_4/services/offline_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
        home: AppHome(
          locale: locale,
          restart: () => setState(() {}),
        ));
  }
}

class AppHome extends ConsumerStatefulWidget {
  const AppHome({required this.locale, required this.restart});
  final Locale locale;
  final VoidCallback restart;

  @override
  ConsumerState<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends ConsumerState<AppHome> {
  Widget _buildHome(bool hasWifi) {
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

  late final StreamSubscription _streamSubscription;
  bool _hasWifi = false;

/*   @override
  initState() {
    super.initState();
    _streamSubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        print('Changed Connectivity: $result');
        _hasWifi = await checkWifi();
        if (_hasWifi) {
          await OfflineService.instance.sendPending();

          ref.read(pendingCounter.notifier).state =
              await OfflineService.instance.getPendingCount();
        }
      } else {
        _hasWifi = false;
      }

      setState(() {});
    });
  } */

  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(seconds: 5), (Timer t) async {
      _hasWifi = await checkWifi();
      if (_hasWifi && mounted) {
        if (OfflineService.instance.isInitiated) {
          await OfflineService.instance.sendPending();
          ref.read(pendingCounter.notifier).state =
              await OfflineService.instance.getPendingCount();
        }
      }
      print('data updated');
    });

    var hasWifi = false;
    return FutureBuilder<void>(
        future: OfflineService.instance.init(),
        builder: (context, snapshot) {
          SizeConfig.init(context);

          if (snapshot.connectionState != ConnectionState.done) {
            return SplashScreen();
          }
          return FutureBuilder<bool>(
              future: checkWifi(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  hasWifi = snapshot.data!;
                  try {
                    return hasWifi
                        ? UpgradeAlert(
                            upgrader: Upgrader(
                                canDismissDialog: false,
                                showIgnore: false,
                                showLater: false,
                                languageCode: widget.locale.languageCode,
                                dialogStyle: Platform.isIOS
                                    ? UpgradeDialogStyle.cupertino
                                    : UpgradeDialogStyle.material),
                            child: _buildHome(hasWifi),
                          )
                        : _buildHome(hasWifi);
                  } catch (e) {
                    //If an error occurs after runnning for the first time, then don't use the upgradeAlert
                    return _buildHome(hasWifi);
                  }
                }
                return const SplashScreen();
              });
        });
  }
}
