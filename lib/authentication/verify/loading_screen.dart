import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:medical_app/authentication/verify/verify_screen.dart';

class LoadingScr extends StatefulWidget {
  const LoadingScr({Key? key, required this.phone}) : super(key: key);
  final String phone;
  @override
  State<LoadingScr> createState() => _LoadingScrState();
}

class _LoadingScrState extends State<LoadingScr> {
  bool isLoading = false;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = true;
      });
      Timer(
          const Duration(seconds: 1),
          () => Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return VerifyScr(
                  phone: widget.phone,
                );
              }), (route) => false));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Column(children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.check_circle_outline,
                      size: 100,
                      color: Colors.green,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Text(
                        'Verification code send on\n your registered mobile number',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(child: Container())
            ])
          : Column(children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SpinKitFadingCircle(
                      size: 100,
                      color: Colors.green,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Text(
                        'Verifying your mobile number',
                        style: TextStyle(fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(child: Container())
            ]),
    );
  }
}
