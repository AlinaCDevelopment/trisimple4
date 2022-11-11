import 'dart:async';

import 'package:app_4/helpers/size_helper.dart';

import '../constants/assets_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../constants/decorations.dart';
import '../widgets/themed_spin_circle.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late String _now;
  late Timer _everySecond;
  int _step = 1;
  int _totalSteps = 12;

  /*  @override
  void initState() {
    super.initState();

    // sets first value
    _now = DateTime.now().second.toString();

    // defines a timer
    _everySecond = Timer.periodic(Duration(milliseconds: 100), (Timer t) {
      setState(() {
        _now = DateTime.now().second.toString();
        if (_step < _totalSteps) {
          _step++;
        } else {
          _step = 0;
        }
      });
    });
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Material(
      color: Colors.black.withOpacity(0.8),
      child: Container(
        decoration: backgroundDecoration,
        child: Center(
            child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ThemedSpinCircle(
                    color: Colors.white,
                    size: SizeConfig.screenWidth * 0.25,
                    childPadding: SizeConfig.screenWidth * 0.25 * 0.36,
                    child: const Text(
                      '4',
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Image.asset(logoImageRoute)
            ],
          ),
        )),
      ),
    ));
  }
}
