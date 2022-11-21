import 'dart:io';
import 'package:app_4/models/database/equipamento.dart';
import 'package:app_4/models/database/evento.dart';
import 'package:app_4/widgets/ui/dialog_messages.dart';
import 'package:http/http.dart';

import '../helpers/size_helper.dart';
import '../screens/splash_screen.dart';
import '../services/database_service.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../screens/container_screen.dart';
import '../providers/auth_provider.dart';
import '../views/scan_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:upgrader/upgrader.dart';

import 'constants/colors.dart';
import 'constants/decorations.dart';
import 'helpers/wifi_verification.dart';
import 'providers/locale_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
      overlays: []);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  var _prefsRead = false;

  bool _hasWifi = false;

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    bool _initialized = false;
    print('built');

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
                print(snapshot.data);
                _hasWifi = snapshot.data!;
                //_hasWifi = snapshot.data == ConnectivityResult.wifi;
                if (_hasWifi) {
                  _hasWifi = true;
                  print('connected');
                  return _hasWifi
                      ? UpgradeAlert(
                          upgrader: Upgrader(
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
                return _buildWifiErrorScreen();
              }
              return SplashScreen();
            }));
  }

  Widget _buildHome(WidgetRef ref) {
    final auth = ref.read(authProvider);

    return FutureBuilder<bool>(
        future: ref.read(authProvider.notifier).authenticateFromPreviousLogs(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data!) {
              return ContainerScreen();
            } else {
              if (_hasWifi == false) {
                return _buildWifiErrorScreen();
              }
              // TODO Detect here internet on ALL APPS
              if (_hasWifi) {
                return FutureBuilder(
                    future: Future.wait([
                      DatabaseService.instance.readEquips(),
                      DatabaseService.instance.readEventos(),
                    ]),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.data?[0] != null &&
                          snapshot.data?[1] != null) {
                        return AuthScreen(
                          equipamentos: snapshot.data![0] as List<Equipamento>,
                          eventos: snapshot.data![1] as List<Evento>,
                        );
                      } else {
                        return const SplashScreen();
                      }
                    });
              }
              return _buildWifiErrorScreen();
            }
          }
          return const SplashScreen();
        });
  }

  Widget _buildWifiErrorScreen() {
    return Scaffold(
        body: Container(
      decoration: backgroundDecoration,
      child: Center(
          child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth * 0.10),
              child: GestureDetector(
                onTap: () async {
                  setState(() {});
                },
                child: DialogMessage(
                  hideExit: true,
                  content: AppLocalizations.of(context).connectionError,
                  title: AppLocalizations.of(context).tryAgain,
                ),
              ))),
    ));
  }
}
