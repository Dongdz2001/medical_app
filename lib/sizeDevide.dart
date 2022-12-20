import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

late double widthDevide;
late double heightDevide;

double widthDevideMethod(double i) => widthDevide * i;
double heightDevideMethod(double i) => heightDevide * i;

// show toast infomation
void showToast(BuildContext context, String msg,
    {int? duration, int? gravity}) {
  ToastContext().init(context);
  Toast.show(msg, duration: duration, gravity: gravity);
}
