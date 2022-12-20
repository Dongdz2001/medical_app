import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medical_app/home/group_screen_folder/group_home_screen.dart';
import 'package:medical_app/manage_patient/manager.dart';
import 'package:medical_app/model/alert_dialog_verification.dart';
import 'package:medical_app/sizeDevide.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationGroupScreen extends StatefulWidget {
  final String? keyLogin;
  const VerificationGroupScreen({Key? key, required this.keyLogin})
      : super(key: key);

  @override
  _VerificationGroupScreenState createState() =>
      _VerificationGroupScreenState();
}

class _VerificationGroupScreenState extends State<VerificationGroupScreen> {
  TextEditingController _keycodeController = TextEditingController();
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String keyLogin;
  @override
  void initState() {
    super.initState();
    keyLogin = this.widget.keyLogin!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(' Xác nhận Nhóm '),
      // ),
      // key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: [
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: heightDevideMethod(0.05),
                  horizontal: widthDevideMethod(0.086)),
              height: heightDevideMethod(0.52),
              color: Color(0xff091a31),
              child: Column(children: [
                Image.asset('assets/itemImage/hospitalback.jpg'),
                const Text(
                  'NHẬP MÃ NHÓM',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                const Text(
                  textAlign: TextAlign.center,
                  'Mã nhóm cho phép mọi người có thể theo dõi một danh sách bệnh nhân cùng một nhóm',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ]),
            ),
            SizedBox(height: heightDevideMethod(0.08)),
            Container(
              width: widthDevideMethod(0.9),
              margin: const EdgeInsets.only(bottom: 10.0),
              child: TextField(
                  keyboardType: TextInputType.text,
                  controller: _keycodeController,
                  decoration: const InputDecoration(
                    prefix: Padding(
                      padding: EdgeInsets.only(right: 8.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(width: 1, color: Colors.black),
                    ),
                    hintText: 'Nhập mã nhóm tại đây ',
                  )),
            ),
            Container(
              width: widthDevideMethod(1),
              padding: EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () async {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialog(
                          keyLogin: this.keyLogin,
                        );
                      });
                  if (Manager(key: keyLogin).keyCodeGroup != "******") {
                    Manager(key: keyLogin).setDefaultAllValueGroup();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GroupScreen(
                            keyCode: Manager(key: keyLogin).keyCodeGroup,
                            keyLogin: keyLogin)));
                  }
                },
                child: Text(
                  textAlign: TextAlign.right,
                  'Tạo tài khoản nhóm .',
                  style: TextStyle().copyWith(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                      fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: heightDevideMethod(0.1),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: NiceButtons(
                stretch: true,
                gradientOrientation: GradientOrientation.Horizontal,
                onTap: (finish) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  if (_keycodeController.text.isEmpty) {
                    _showToast('Hãy nhập mã nhóm', 2);
                  } else {
                    CollectionReference users = await FirebaseFirestore.instance
                        .collection(_keycodeController.text);
                    await users
                        .doc('informationGroup')
                        .get()
                        .then((DocumentSnapshot value) async {
                      if (!value.exists) {
                        _showToast("Mã nhóm không tồn tại ", 3);
                      } else {
                        // String keyLoginCreatorTemp =
                        //     value["keylogin_of_creator"];
                        // keyLogin == keyLoginCreatorTemp
                        //     ? Manager(key: keyLogin).keyCodeGroup =
                        //         _keycodeController.text
                        //     : '******';
                        Manager(key: keyLogin).keyCodeGroup =
                            _keycodeController.text;
                        Manager(key: keyLogin).nameGroupJoin =
                            value["name_group"];
                        _showToast(
                            "Đăng nhập thành công chờ trong giây lát", 2);
                        await prefs.setString(
                            'keyCodeLocal', _keycodeController.text.toString());
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => GroupScreen(
                                      keyLogin: keyLogin,
                                      keyCode: _keycodeController.text,
                                    )),
                            (route) => false);
                      }
                    });
                  }

                  print("finish is:   $finish");
                },
                child: Text(
                  'Xác nhận',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // Thông báo khi nhập dữ liệu
  void _showToast(String content, int time) {
    Fluttertoast.showToast(
        msg: content,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: time,
        backgroundColor: const Color.fromARGB(255, 3, 42, 75),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void pushNewScreeen(String keycde) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                GroupScreen(keyCode: keycde, keyLogin: keyLogin)));
  }
}
