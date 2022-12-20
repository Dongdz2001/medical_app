import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/manage_patient/manager.dart';
import 'package:medical_app/sizeDevide.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDialog extends StatelessWidget {
  final String? keyLogin;
  const CustomDialog({
    Key? key,
    required this.keyLogin,
  }) : super(key: key);
  dialogContent(BuildContext context) {
    TextEditingController _nameGroup = new TextEditingController();
    TextEditingController _keyCodeGroup = new TextEditingController();

    return Container(
      width: widthDevideMethod(1),
      height: 230.0,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
      ),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          // dialog top
          new Expanded(
            child: new Row(
              children: <Widget>[
                new Container(
                  padding: new EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(),
                  child: new Text(
                    'Tên:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontFamily: 'helvetica_neue_light',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: widthDevideMethod(0.6),
                  child: TextField(
                    controller: _nameGroup,
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(top: 5, left: 5),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      hintText: 'Tên hiển thị của nhóm',
                    ),
                  ),
                ),
              ],
            ),
          ),

          new Expanded(
            child: new Row(
              children: <Widget>[
                new Container(
                  padding: new EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(),
                  child: new Text(
                    'Mã :',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontFamily: 'helvetica_neue_light',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: widthDevideMethod(0.6),
                  child: TextField(
                    controller: _keyCodeGroup,
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(top: 5, left: 5),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      hintText: 'Mã code của nhóm',
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // dialog bottom
          InkWell(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (_keyCodeGroup.text.isEmpty) {
                _showToastType2("Mã nhóm không được để trống", 2);
              } else if (_nameGroup.text.isEmpty) {
                _showToastType2("Tên nhóm không được để trống", 2);
              } else if (_keyCodeGroup.text.length < 6) {
                _showToastType2("Mã nhóm ít nhất là 6 ký tự", 2);
              } else if (_keyCodeGroup.text.length > 10) {
                _showToastType2('Mã nhóm không quá 10 ký tự', 2);
              } else if (_nameGroup.text.length > 25 ||
                  _nameGroup.text.length < 3) {
                _showToastType2('Tên nhóm khoảng (3,25) ký tự', 2);
              } else {
                CollectionReference users = await FirebaseFirestore.instance
                    .collection(_keyCodeGroup.text);
                users.get().then((QuerySnapshot querySnapshot) async {
                  if ((querySnapshot.docs.isEmpty)) {
                    _showToastType2("Tạo nhóm thành công xin chờ .. !", 3);

                    await prefs.setString('keyLocalLogin', _keyCodeGroup.text);
                    await addNewGroup(users, _nameGroup.text);
                    await addNewListPateintOfGroup(users);
                    Manager(key: keyLogin!).keyCodeGroup = _keyCodeGroup.text;
                    Manager(key: keyLogin!).nameGroupJoin = _nameGroup.text;
                    Navigator.pop(context);

                    // VerificationGroupScreen(keyLogin: keyLogin).pushNewScreeen;
                    await saveDataLocal(_keyCodeGroup.text);
                  } else {
                    _showToastType2("Mã nhóm đã tồn tại", 3);
                  }
                });
              }
            },
            child: Container(
              padding: new EdgeInsets.all(16.0),
              decoration: new BoxDecoration(
                color: const Color(0xFF33b17c),
                borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
              ),
              child: new Text(
                'Tạo nhóm',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontFamily: 'helvetica_neue_light',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
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

  // Tổng hợp tất cả các function add FireStore bên dưới
  // Future<void> addNewGroupAllInfo(
  //     CollectionReference users, String strNameGroup) async {
  //   await addNewGroup(users, strNameGroup);
  //   await addNewListMemberOfGroup(users);
  //   await addNewListPateintOfGroup(users);
  // }

  // Tạo group mới trên FireStore và lưu tên Group vào document[0]
  Future<void> addNewGroup(CollectionReference users, String nameGroup) async {
    // CollectionReference users = FirebaseFirestore.instance.collection(keyCode);
    return await users
        .doc("informationGroup")
        .set({
          'name_group': nameGroup,
          'name_creator': Manager(key: keyLogin!).nameUser,
          'keylogin_of_creator': keyLogin!,
          'email_creator': FirebaseAuth.instance.currentUser!.email,
        })
        .then((value) => print("This Group was added"))
        .catchError((onError) => print("Failed to add this Group: $onError"));
  }

  //  add info list member of group
  Future<void> addNewListMemberOfGroup(CollectionReference users) async =>
      await users
          .add({
            'list_member': [],
          })
          .then((value) => print("This new List Member Of Group was added"))
          .catchError((onError) =>
              print("Failed to add new List Mem Of Group: $onError"));
  Future<void> addNewListPateintOfGroup(CollectionReference users) async =>
      users
          .doc("information_Pateint")
          .set({
            'list_pateint': [],
          })
          .then((value) => print("This new List Patient Of Group was added"))
          .catchError((onError) =>
              print("Failed to add new List Patient Of Group: $onError"));
  Future<void> saveDataLocal(String keycode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('keyCodeLocal', keycode);
  }
}
