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
const backMaterialColor = MaterialColor(0xFF453A98, _backColorMap);

const backGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: gradientColors);

const brightColor = Color.fromRGBO(215, 114, 251, 1);

const _brightColorMap = {
  50: Color.fromRGBO(215, 114, 251, .1),
  100: Color.fromRGBO(215, 114, 251, .2),
  200: Color.fromRGBO(215, 114, 251, .3),
  300: Color.fromRGBO(215, 114, 251, .4),
  400: Color.fromRGBO(215, 114, 251, .5),
  500: Color.fromRGBO(215, 114, 251, .6),
  600: Color.fromRGBO(215, 114, 251, .7),
  700: Color.fromRGBO(215, 114, 251, .8),
  800: Color.fromRGBO(215, 114, 251, .9),
  900: Color.fromRGBO(215, 114, 251, 1),
};

const brightMaterialColor = MaterialColor(0xFFD772FB, _brightColorMap);

const accentColor = Color(0xFFFFBF67);

const gradientColors = <Color>[
  Color(0xFF9672FB),
  Color(0xFFD772FB),
];

const secondColor = Color.fromRGBO(215, 114, 251, 1);
const thirdColor = Color.fromRGBO(6, 163, 195, 1);

const hintColor = Color(0xFF8780BA);
const canvasColor = Colors.white;

const appBarTextColor = Color.fromRGBO(218, 124, 250, 1);
const appBarColor = Colors.white;


const buttonGradient = LinearGradient(
                      colors: gradientColors,
                      end: Alignment.bottomLeft,
                      begin: Alignment.topRight);