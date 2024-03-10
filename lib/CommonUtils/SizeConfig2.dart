import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData = MediaQueryData();
  static double screenWidth = 0;
  static double screenHeight= 0;
  static double blockSizeHorizontal= 0;
  static double blockSizeVertical= 0;
  static double _safeAreaHorizontal= 0;
  static double safeAreaVertical= 0;
  static double safeBlockHorizontal= 0;
  static double safeBlockVerticalWithAppBar= 0;
  static double safeBlockVerticalWithOutAppBar= 0;
  static double allAppHaveAppBar= 0;
  static double textScaleFactor= 0;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    safeAreaVertical = MediaQueryData.fromWindow(window).padding.top +
        MediaQueryData.fromWindow(window).padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    //you need to divedied py 100  to use ===> (safeBlockVerticalWithAppBar/100)
    safeBlockVerticalWithAppBar =
        (screenHeight - safeAreaVertical - AppBar().preferredSize.height) / 100;
    safeBlockVerticalWithOutAppBar =
        (screenHeight - safeAreaVertical - 0) / 100;
    //if all app have appbar you can use this propirty
    allAppHaveAppBar =
        (screenHeight - safeAreaVertical - AppBar().preferredSize.height) / 100;

    textScaleFactor = (min(MediaQuery.of(context).size.height / 690,
        MediaQuery.of(context).size.width / 360));
  }
}
