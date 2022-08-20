import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login/home_screen.dart';
import 'authen_service.dart';

class FireBaseHelper implements AuthenService {
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late String _verificationCode;

  static FireBaseHelper setup() {
    if (_firebaseAuth == null) {
      _firebaseAuth = FirebaseAuth.instance;
    }
    return FireBaseHelper();
  }

  @override
  Future<void> verifyPhone(String phone) async {
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+1${phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential).then((value) {
            if (value.user != null) {
              print(value.user);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationCode = verificationId;
          print(resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          _verificationCode = verificationID;
        },
        timeout: Duration(seconds: 120));
  }

  @override
  Future<void> verifyPin(String pinCode, BuildContext context) async {
    await _firebaseAuth
        .signInWithCredential(PhoneAuthProvider.credential(
            verificationId: _verificationCode, smsCode: pinCode))
        .then((value) async {
      if (value.user != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                      keyLogin: value.user!.uid.toString(),
                    )),
            (route) => false);
      }
    });
  }
}
