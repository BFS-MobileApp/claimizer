import 'package:flutter/material.dart';

abstract class IBaseView {
  BuildContext getContext();
  bool get mounted;
  void showProgress();

  void closeProgress();

  void showToasts(String msg,String status);

  double sWidth(double w);
  double sHeight(double h);
  double sTextSize(double web, double tablet);
}
