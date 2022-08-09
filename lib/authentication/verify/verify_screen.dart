import 'package:flutter/material.dart';

import 'package:pinput/pinput.dart';

import '../service/firebase_helper.dart';

class VerifyScr extends StatefulWidget {
  VerifyScr({Key? key, required this.phone}) : super(key: key);

  final String phone;
  final FireBaseHelper _auth = FireBaseHelper.setup();

  @override
  State<VerifyScr> createState() => _VerifyScrState();
}

class _VerifyScrState extends State<VerifyScr> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  late String _verificationCode;

  @override
  void initState() {
    super.initState();
    widget._auth.verifyPhone('${widget.phone}');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromARGB(255, 95, 99, 103),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 249, 250, 250)),
        borderRadius: BorderRadius.circular(30),
      ),
    );
    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return Scaffold(
        key: _scaffoldkey,
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter the 6 digit code that was\n send to your Mobile Number',
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Pinput(
                  length: 6,
                  controller: _pinPutController,
                  focusNode: _pinPutFocusNode,
                  defaultPinTheme: submittedPinTheme,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                width: size.width * 0.8,
                height: size.height * 0.06,
                child: RaisedButton(
                  color: Colors.green,
                  onPressed: () async {
                    try {
                      await widget._auth
                          .verifyPin(_pinPutController.text, context);
                    } catch (e) {
                      FocusScope.of(context).unfocus();
                      _pinPutController.text = '';
                      _scaffoldkey.currentState?.showSnackBar(
                          const SnackBar(content: Text('Invalid OTP')));
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    "Verify",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
