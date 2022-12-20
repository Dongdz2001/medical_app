import 'package:flutter/material.dart';
import 'package:medical_app/authentication/login/signup.dart';

import 'login.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.white,
        child: Column(children: <Widget>[
          const SizedBox(
            height: 200,
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 80),
              color: Colors.deepPurple,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(32.0)),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(fontSize: 18.0),
                  )),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(18.0),
            child: Text("Don't have an account?"),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 72),
              color: Colors.purple[50],
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUp()));
                  },
                  child: const Text(
                    'SIGN UP',
                    style: TextStyle(fontSize: 18.0),
                  )),
            ),
          ),
        ]),
      ),
    );
  }
}
