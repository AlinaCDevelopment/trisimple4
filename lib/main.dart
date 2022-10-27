import 'dart:io';

import 'package:app_4/screens/scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upgrader/upgrader.dart';

import 'constants/colors.dart';
import 'screens/auth_screen.dart';

//TODO Set at start the screen size instead of using media queries everywhere
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  final isAuthenticated = true;
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
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
      home: UpgradeAlert(
        upgrader: Upgrader(
            // durationUntilAlertAgain: const Duration(hours: 8),
            dialogStyle: Platform.isIOS
                ? UpgradeDialogStyle.cupertino
                : UpgradeDialogStyle.material),
        child: isAuthenticated ? const ScanScreen() : const AuthScreen(),
      ),

      routes: {
        AuthScreen.routeName: (context) => const AuthScreen(),
        ScanScreen.routeName: (context) => const ScanScreen(),
      },
    );
  }
}
