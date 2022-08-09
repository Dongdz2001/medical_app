import 'package:flutter/material.dart';

import 'loading_screen.dart';

class LoginSc extends StatefulWidget {
  const LoginSc({Key? key}) : super(key: key);

  @override
  State<LoginSc> createState() => _LoginScState();
}

class _LoginScState extends State<LoginSc> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextEditingController phoneController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.1,
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                child: const Text(
                  'Phone Number',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 40),
                ),
              ),
              Column(children: [
                Container(
                  width: size.width * 0.8,
                  margin: const EdgeInsets.only(bottom: 10.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: phoneController,
                    decoration: const InputDecoration(
                      prefix: Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text('+1'),
                      ),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      hintText: 'Enter your mobile number',
                    ),
                    onSubmitted: (value) {
                      if (value != '' && value.length == 10) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoadingScr(
                                    phone: phoneController.text,
                                  )),
                        );
                      }
                    },
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
