import 'package:flutter/material.dart';

class User{
  final String uid="";
  String getUser(){
    return uid;
  }
}
abstract class AuthenService{
  Future<void> verifyPhone(String phone);
  Future<void> verifyPin(String pinCode, BuildContext context);
}