// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medical_app/home/home_screen_main_login.dart';
import 'package:medical_app/sizeDevide.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../manage_patient/manager.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameUserController = TextEditingController();
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
                  prefixIcon: const Icon(Icons.person),
                  hintText: 'Họ tên của bạn ?',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22.0)),
                ),
                onChanged: (value) => setState(() {
                  _nameUserController.text = value;
                }),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    hintText: 'Email của bạn ?',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22.0)),
                  ),
                  onChanged: (value) => setState(() {
                    _email.text = value;
                  }),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      hintText: 'Nhập mật khẩu',
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
                      hintText: 'Nhập lại mật khẩu',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: const BorderSide(
                              color: Colors.black, width: 2.0))),
                  onChanged: (value) => setState(() {
                    _confirm = value;
                  }),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  width: widthDevideMethod(1),
                  height: heightDevideMethod(0.118),
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 72),
                  // color: const Color.fromARGB(255, 48, 81, 245),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 48, 81, 245)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                                side: BorderSide(
                                    color: Color.fromARGB(255, 55, 59, 89))),
                          )),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        if (_confirm == _password.text &&
                            _nameUserController.text != '') {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: _email.text, password: _password.text)
                              .then((signedInUser) async {
                            showToast(
                                "Tạo tài khoản thành công, \n vui lòng chờ trong giây lát...",
                                2);

                            CollectionReference users = await FirebaseFirestore
                                .instance
                                .collection('listPasswordOfUsers');

                            users
                                .doc(_email.text)
                                .set({
                                  'password': _password.text,
                                  'nameUser': _nameUserController.text,
                                })
                                .then((value) => print("User Added"))
                                .catchError((error) =>
                                    print("Failed to add user: $error"));

                            await prefs.setString(
                                'keyLocalLogin', signedInUser.user!.uid);

                            Manager(key: signedInUser.user!.uid).nameUser =
                                this._nameUserController.text;
                            Manager(key: signedInUser.user!.uid).nameEmailUser =
                                signedInUser.user!.email ??
                                    'nonenone@gmail.com';
                            Manager(key: signedInUser.user!.uid).keyLogin =
                                signedInUser.user!.uid;
                            await Manager(key: signedInUser.user!.uid)
                                .saveNameUser(this._nameUserController.text);
                            await Manager(key: signedInUser.user!.uid)
                                .saveNameEmailUser(this._email.text);

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreenMainLogin(
                                          keyLogin: signedInUser.user!.uid,
                                        )));
                          }).catchError((e) {
                            if (e.toString().indexOf('connection') != -1) {
                              showToast("Không có kết nối internet", 2);
                            } else {
                              showToast("Tài khoản đã tồn tại", 2);
                            }
                          });
                        } else {
                          if (_confirm != _password.text) {
                            showToast("Mật khẩu không trùng khớp", 2);
                          } else {
                            showToast("Tên không được để trống", 2);
                          }
                        }
                      },
                      child: const Text(
                        'Đăng ký',
                        style: TextStyle(fontSize: 18.0),
                      )),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20),
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  width: 130,
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
                              "Đăng nhập",
                              style: TextStyle(
                                color: Color.fromARGB(255, 52, 50, 50),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Login()),
                                  ModalRoute.withName('/signup'));
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
        backgroundColor: const Color(0xff091a31),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
