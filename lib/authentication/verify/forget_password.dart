import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medical_app/sizeDevide.dart';
import 'package:email_auth/email_auth.dart';

enum AuthStatus {
  successful,
  wrongPassword,
  emailAlreadyExists,
  invalidEmail,
  weakPassword,
  unknown,
}

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  String _passwordReceiveFromFireStore = "";
  String _receiveEmailInput = "";
  final TextEditingController _emailController = TextEditingController();
  EmailAuth emailAuth = new EmailAuth(
    sessionName: "Medical app",
  );
  bool submitValid = false;
  bool flagShowResetPassWord = false;

  Future<void> resetPassWordFireBaseAuth(String newpassword) async {
    //Create an instance of the current user.
    print(
        "email_receive= $_receiveEmailInput pass receive= $_passwordReceiveFromFireStore");

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _receiveEmailInput,
        password: _passwordReceiveFromFireStore,
      );
      var user = FirebaseAuth.instance.currentUser!;

      user.updatePassword(newpassword).then((_) async {
        print("Successfully changed password");
        _showToastType2("Đổi mật khẩu thành công !", 3);
        CollectionReference users =
            await FirebaseFirestore.instance.collection('listPasswordOfUsers');

        users
            .doc(_receiveEmailInput)
            .update({'password': newpassword})
            .then((value) => print("User Added"))
            .catchError((error) => print("Failed to add user: $error"));
        Navigator.pop(context);
      }).catchError((error) {
        print("Password can't be changed" + error.toString());
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  //  xác thực mã OTP nhận được qua gmail
  Future<void> verify() async {
    bool verifyOTP = await emailAuth.validateOtp(
        recipientMail: _receiveEmailInput,
        userOtp: _emailController.value.text);
    if (verifyOTP) {
      _showToastType2('Xác thực OTP thành công !', 2);
      setState(() {
        flagShowResetPassWord = true;
        _emailController.text = "";
      });
    } else {
      _showToastType2('Mã OTP không chính xác !', 2);
    }
  }

  // gửi mã OTP về gmail
  Future<void> sendOtp() async {
    bool flagExistEmailAuth = false;
    _showToastType2('Đang xác thực Gmail', 2);

    await FirebaseFirestore.instance
        .collection('listPasswordOfUsers')
        .doc(_emailController.text)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        // print('Document data: ${documentSnapshot.data()}');
        _passwordReceiveFromFireStore = documentSnapshot['password'];
        print("pass = $_passwordReceiveFromFireStore");
        flagExistEmailAuth = true;
      }
    });

    if (!flagExistEmailAuth) {
      _showToastType2('Gmail bạn nhập không được đăng ký', 3);
    } else {
      _showToastType2('Xác thực Gmail thành công chờ xíu', 2);
      bool result = await emailAuth.sendOtp(
          recipientMail: _emailController.value.text, otpLength: 5);
      if (result) {
        _showToastType2('Mã OTP đã được gửi tới gmail của bạn', 3);
        // using a void function because i am using a
        // stateful widget and seting the state from here.
        setState(() {
          submitValid = true;
          _receiveEmailInput = _emailController.text;
          _emailController.text = "";
        });
      } else {
        _showToastType2('Không gửi được mã OTP tới gmail này', 3);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: heightDevideMethod(1),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color.fromARGB(255, 38, 115, 248),
              Colors.white,
            ])),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                      padding: EdgeInsets.only(top: 15, left: 5),
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.arrow_back,
                        size: 35,
                        color: Colors.white,
                      )),
                ),
                SizedBox(
                  height: heightDevideMethod(0.1),
                ),
                SizedBox(
                    width: widthDevideMethod(0.7),
                    child: Image.asset("assets/images/forgotPassword.png",
                        fit: BoxFit.fitHeight)),
                SizedBox(
                  height: heightDevideMethod(0.05),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Quên mật khẩu ?',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 54, 44, 247),
                        fontSize: 28),
                  ),
                ),
                SizedBox(
                  height: heightDevideMethod(0.01),
                ),
                Text(
                  'Nhập địa chỉ email của bạn xuống bên dưới \n để lấy lại mật khẩu đăng nhập của bạn',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color.fromARGB(255, 80, 71, 71),
                      fontSize: 18),
                ),
                SizedBox(
                  height: heightDevideMethod(0.04),
                ),
                Container(
                  width: size.width * 0.9,
                  margin: const EdgeInsets.only(bottom: 10.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefix: Padding(
                        padding: EdgeInsets.only(right: 8.0),
                      ),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      hintText: submitValid
                          ? !flagShowResetPassWord
                              ? 'Nhập mã OTP'
                              : 'Nhập mật khẩu mới'
                          : 'Nhập địa chỉ email',
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.only(top: 20),
                  elevation: 6,
                  child: Container(
                    height: 50,
                    width: 200,
                    color: Colors.green[400],
                    child: InkWell(
                      onTap: () {
                        submitValid
                            ? !flagShowResetPassWord
                                ? verify()
                                : resetPassWordFireBaseAuth(
                                    _emailController.text)
                            : sendOtp();
                      },
                      child: Center(
                        child: Text(
                          submitValid
                              ? !flagShowResetPassWord
                                  ? "Xác thực OTP"
                                  : "Đổi mật khẩu"
                              : "Nhận mã OTP",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Thông báo khi nhập dữ liệu
  void _showToastType2(String content, int time) {
    Fluttertoast.showToast(
        msg: content,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: time,
        backgroundColor: const Color.fromARGB(255, 3, 42, 75),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
