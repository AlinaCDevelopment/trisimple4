import 'package:flutter/material.dart';

const _backColorMap = {
  50: Color.fromRGBO(69, 58, 152, .1),
  100: Color.fromRGBO(69, 58, 152, .2),
  200: Color.fromRGBO(69, 58, 152, .3),
  300: Color.fromRGBO(69, 58, 152, .4),
  400: Color.fromRGBO(69, 58, 152, .5),
  500: Color.fromRGBO(69, 58, 152, .6),
  600: Color.fromRGBO(69, 58, 152, .7),
  700: Color.fromRGBO(69, 58, 152, .8),
  800: Color.fromRGBO(69, 58, 152, .9),
  900: Color.fromRGBO(69, 58, 152, 1),
};
const backColor = MaterialColor(0xFF453A98, _backColorMap);

const backGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: gradientColors);

const brightColor = Color(0xFFD772FB);
const accentColor = Color(0xFFFFBF67);

const gradientColors = <Color>[
  Color(0xFF9672FB),
  Color(0xFFD772FB),
];
const secondColor = Color(0xFF8780BA);

const hintColor = secondColor;
const canvasColor = Colors.white;
