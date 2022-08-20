// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../service/user.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String? _confirm;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.deepPurple,
      //   title: const Text('Sign Up Form'),
      // ),
      body: Container(
        padding: const EdgeInsets.only(top: 100),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blueAccent,
            Colors.white,
          ],
        )),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Container(
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: Image.asset('assets/images/icon_doctor.png'),
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22.0)),
                ),
                onChanged: (value) => setState(() {
                  _email.text = value;
                }),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      hintText: 'Enter password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.0))),
                  onChanged: (value) => setState(() {
                    _password.text = value;
                  }),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.confirmation_num_rounded),
                      hintText: 'Confirm password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: const BorderSide(
                              color: Colors.black, width: 2.0))),
                  onChanged: (value) => setState(() {
                    print(value);
                    _confirm = value;
                  }),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 30),
                child: FlatButton(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 72),
                    color: const Color.fromARGB(255, 48, 81, 245),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                    onPressed: () async {
                      if (_confirm == _password.text) {
                        showToast(
                            "successful, please wait a few seconds ...", 2);
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: _email.text, password: _password.text)
                            .then((signedInUser) {
                          UserManagement().storeNewUser(signedInUser, context);
                        }).catchError((e) {
                          print(e);
                        });
                      } else {
                        showToast("Password doesn't match !", 1);
                      }
                    },
                    child: const Text(
                      'SIGN UP',
                      style: TextStyle(fontSize: 18.0),
                    )),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20),
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  width: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 78, 170, 255),
                    ),
                    padding: const EdgeInsets.all(5),
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.login_outlined),
                        InkWell(
                            child: const Text(
                              "Sign in",
                              style: TextStyle(
                                color: Color.fromARGB(255, 52, 50, 50),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showToast(String content, int time) {
    Fluttertoast.showToast(
        msg: content,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: time,
        backgroundColor: const Color.fromARGB(255, 51, 123, 230),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
