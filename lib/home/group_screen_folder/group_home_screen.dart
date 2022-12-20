import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/home/group_screen_folder/verification_group_screen.dart';
import 'package:medical_app/home/history_pateint_screen.dart';
import 'package:medical_app/NDDTM_medical/medical_home_screen.dart';
import 'package:medical_app/sizeDevide.dart';
import 'package:medical_app/manage_patient/patient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../../manage_patient/manager.dart';
import 'package:group_radio_button/group_radio_button.dart';

class GroupScreen extends StatefulWidget {
  final String? keyCode;
  final String? keyLogin;

  const GroupScreen({Key? key, required this.keyLogin, required this.keyCode})
      : super(key: key);

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  late String keyLogin;
  late String? myEmail = '';
  late String? keyCode;
  final ScrollController _controllerScroll = ScrollController();
  PageController _controllerPage = PageController();
  bool onLastPage = false;
  final items = [
    'Nuôi dưỡng đường tĩnh mạch',
    'Nuôi cấy tế bào gốc',
    'Điều trị đau vai gáy'
  ];

  // String? value = "Nuôi dưỡng đường tĩnh mạch";
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _idController = new TextEditingController();
  final TextEditingController _weightController = new TextEditingController();
  final TextEditingController _dateController = new TextEditingController();
  int _groupValue = -1;

  AnimationController? expandController;
  Animation<double>? animation;
  late Manager manager;
  late Future<String> lockReadData;

  @override
  void initState() {
    // TODO: implement initState

    keyLogin = widget.keyLogin!;
    keyCode = widget.keyCode!;
    manager = Manager(key: keyLogin);
    // print("keycurrent =  ${keyLogin}");
    // lockReadData = manager.readDataFireStoreDBManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AnimationController controller;
    Animation<Offset> offset;
    Patien patien = Patien(name: "None", veryfileID: "None");

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff091a31),
          automaticallyImplyLeading: false,
          title: ListTile(
            title: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                'Tên Nhóm: ${manager.nameGroupJoin}',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            subtitle: Text(
              'Mã nhóm: ${manager.keyCodeGroup!}',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          actions: [
            Container(
                padding: EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('keyCodeLocal', '');
                    Manager(key: keyLogin).keyCodeGroup = '******';
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => VerificationGroupScreen(
                                  keyLogin: keyLogin,
                                )),
                        (route) => false);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.login_outlined,
                        size: 30,
                      ),
                      Text(
                        'Thoát',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                )),
          ],
        ),
        // List hiển thị tên bệnh nhân và phác đồ
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(keyCode!)
                .doc('information_Pateint')
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              // FutureBuilder(
              //     future: lockReadData,
              //     builder: (context, snapshot) {

              if (!snapshot.hasData) {
                List<Widget> children = const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  )
                ];
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ),
                );
              }
              // else if (snapshot.hasError) {
              //   print("error Data Group");
              //   children = <Widget>[
              //     const Icon(
              //       Icons.error_outline,
              //       color: Colors.red,
              //       size: 60,
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.only(top: 16),
              //       child: Text('Error: ${snapshot.error}'),
              //     )
              //   ];
              // }

              // children = const <Widget>[
              //   SizedBox(
              //     width: 60,
              //     height: 60,
              //     child: CircularProgressIndicator(),
              //   ),
              //   Padding(
              //     padding: EdgeInsets.only(top: 16),
              //     child: Text('Awaiting result...'),
              //   )
              // ];
              try {
                var value = snapshot.data;
                manager.back_steps_selectGroup =
                    value!["back_steps_select"] ?? -1;
                List<dynamic> listTemp = value["listInfo"] ?? [];
                manager.listInfomationGroup =
                    (listTemp).map((e) => e.toString()).toList();

                listTemp = value["listSelected"] ?? [];
                manager.listSelectedGroup =
                    (listTemp).map((e) => e.toString() == 'true').toList();

                listTemp = value["listHistoryInfo"] ?? [];
                manager.listHistoryInfomationGroup =
                    (listTemp).map((e) => e.toString()).toList();
              } catch (e) {}

              List<Widget> children = <Widget>[
                Expanded(
                  child: Stack(
                    children: [
                      // height: MediaQuery.of(context).size.height - 250,
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListView.builder(
                              itemCount: manager.listInfomationGroup.length != 0
                                  ? manager.listInfomationGroup.length
                                  : 0,
                              controller: _controllerScroll,
                              physics: ScrollPhysics(parent: null),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => Container(
                                // color: Colors.orange,
                                padding: EdgeInsets.only(bottom: 5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25.0),
                                  child: Card(
                                    elevation: 5,
                                    shape: Border(
                                        right: BorderSide(
                                            color:
                                                manager.listSelectedGroup[index]
                                                    ? Colors.red
                                                    : Colors.green,
                                            width: 5)),
                                    color: Colors.white,
                                    shadowColor: Colors.blueAccent,
                                    // ListTile Event
                                    child: ListTile(
                                      onTap: () async {
                                        patien.setID = manager
                                            .getIdPatientIndexGroup(index);
                                        await patien.readDataFireStoreDB(
                                            keyCode!, "Users.${patien.getID}");

                                        setState(() {
                                          if (manager.back_steps_selectGroup ==
                                              -1) {
                                            manager.back_steps_selectGroup =
                                                index;
                                            manager.setSelectGroup(
                                                manager.back_steps_selectGroup);
                                          } else if (manager
                                                  .back_steps_selectGroup !=
                                              index) {
                                            manager.setSelectGroup(
                                                manager.back_steps_selectGroup);
                                            manager.setSelectGroup(index);
                                            manager.back_steps_selectGroup =
                                                index;
                                            print(
                                                "backSteps= ${manager.back_steps_selectGroup}");
                                          }
                                          manager
                                              .upSever_FireStore_ListSelected();
                                          _navigateAndDisplaySelection(
                                              context, index, patien);
                                        });
                                      },
                                      onLongPress: () async {
                                        await _showDialogDeletePatient(index);
                                      },
                                      // ảnh của mỗi bệnh nhân
                                      leading: SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqkKsJE9otzQr3RAnkLRCThzaxfoJ0_6W2sg&usqp=CAU")),
                                      ),
                                      trailing: Icon(Icons.alarm_add_rounded),

                                      title: Text(
                                        manager.getNameInfoPatientIndexGroup(
                                            index),
                                        // manager.getList()![index].getName,
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      // Hien thi Phác đồ duoi ten benh nhan
                                      subtitle: // Chọn phác đồ
                                          Padding(
                                        padding:
                                            const EdgeInsets.only(right: 40),
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 8),
                                            child: Container(
                                              padding: EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 1),
                                              ),
                                              child: DropdownButton<String>(
                                                value: patien.getRegimen,
                                                isExpanded: true,
                                                items: items
                                                    .map(buildMenuItem)
                                                    .toList(),
                                                onChanged: (val) =>
                                                    setState(() {
                                                  patien.setRegimen = val;
                                                }),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Button add image (btim)
                      Positioned(
                        right: 10,
                        bottom: 40,
                        child: GestureDetector(
                          onTap: () {
                            _modalBottomSheetMenu();
                          },
                          child: SizedBox(
                            height: 80,
                            width: 80,
                            child: ClipOval(
                                child: Image.asset(
                              "assets/add_users.jpg",
                              fit: BoxFit.fill,
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ];

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              );
            }));
  }

  Future<void> _navigateAndDisplaySelection(
      BuildContext context, int index, Patien patien) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => MedicalHomeScreen(
                  checkGroupOrPerSonal: true,
                  patienTemp: patien,
                  index: index,
                  keyCode: this.keyCode,
                ))));
    try {
      if (result) {
        setState(() {});
      }
    } catch (e) {
      print("null pop error");
    }
  }

// Tạo danh sách lựa chọn phác đồ điều trị
  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(
            fontSize: 15,
          ),
          maxLines: 1,
        ),
      );
// pop up thêm bệnh nhân mới
  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        enableDrag: true,
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState1 /*You can rename this!*/) {
            return FractionallySizedBox(
              heightFactor: 0.6,
              child: Material(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(height: heightDevideMethod(0.01)),
                        _buildUserInfoDisplay(_nameController, 'Họ tên:',
                            "Dương Minh Đông", TextInputType.text),
                        _buildUserInfoDisplay(_idController, 'Mã bệnh nhân:',
                            "12345abcde", TextInputType.text),
                        _buildUserInfoDisplay(
                          _weightController,
                          'Cân nặng hiện tại (Kg):',
                          "60",
                          TextInputType.number,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            height: heightDevideMethod(0.07),
                            child: Row(
                              children: [
                                SizedBox(width: widthDevideMethod(0.02)),
                                Text('Giới Tính:'),
                                SizedBox(width: widthDevideMethod(0.03)),
                                Container(
                                  height: 39,
                                  width: 230,
                                  child: Row(
                                    children: <Widget>[
                                      RadioButton(
                                        description: "Nam",
                                        value: 1,
                                        groupValue: _groupValue,
                                        onChanged: (value) {
                                          setState1(() {
                                            _groupValue =
                                                int.parse(value.toString());
                                          });
                                        },
                                      ),
                                      RadioButton(
                                        description: "Nữ",
                                        value: 0,
                                        groupValue: _groupValue,
                                        onChanged: (value) {
                                          setState1(() {
                                            _groupValue =
                                                int.parse(value.toString());
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _buildUserInfoDisplay(_dateController, 'Ngày sinh:',
                            "04/01/2001", TextInputType.datetime),
                        SizedBox(height: heightDevideMethod(0.01)),
                        SizedBox(
                          height: heightDevideMethod(0.06),
                          width: widthDevideMethod(0.5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 14, 38, 71), // background
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'Thêm bệnh nhân',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              if ((_nameController.text != "") &
                                  (_idController.text.length == 10) &
                                  (_weightController.text != "") &
                                  !manager.checkIDExistIDGroup(
                                      _idController.text.toString())) {
                                // thêm thông tin bệnh nhân vao listInfomationGroup
                                // manager.readDataFireStoreDBManager();
                                manager.addListInformationGroup(
                                    _idController.text, _nameController.text);
                                print("checkcheck= $keyLogin");
                                Patien patien = Patien(
                                    name: _nameController.text,
                                    veryfileID: _idController.text,
                                    weight:
                                        double.parse(_weightController.text),
                                    gender: _groupValue == 1 ? "Nam" : "Nữ",
                                    birthday: _dateController.text,
                                    regimen: 'Nuôi dưỡng đường tĩnh mạch')
                                  ..saveDataPatient(true, keyLogin, false,
                                      keyCodeGroup: keyCode!);
                                await manager.upServerListInfoFireStore();
                                Navigator.pop(context);
                              } else {
                                if (_nameController.text == "") {
                                  showToast(
                                      context, "Họ tên không được để trống",
                                      duration: 3, gravity: Toast.bottom);
                                } else if (_idController.text.length != 10) {
                                  showToast(context,
                                      "Mã bệnh nhân không đúng 10 chữ số",
                                      duration: 3, gravity: Toast.bottom);
                                } else if (_weightController.text == "") {
                                  showToast(
                                      context, "Cân nặng không được để trống",
                                      duration: 3, gravity: Toast.bottom);
                                } else {
                                  showToast(context, "Mã bệnh nhân đã tồn tại",
                                      duration: 3, gravity: Toast.bottom);
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  // Widget builds the display item with the proper formatting to display the user's info
  Widget _buildUserInfoDisplay(TextEditingController _editControler,
      String title, String hint, TextInputType textInput) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(10)),
        height: heightDevideMethod(0.07),
        child: Row(
          children: [
            SizedBox(width: widthDevideMethod(0.02)),
            Text(title),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 5, 5, 2),
                height: heightDevideMethod(0.07),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  // border: Border.all(color: Colors.black),
                ),
                child: TextField(
                  keyboardType: textInput,
                  style: TextStyle(
                      fontSize: 20.0, height: 2.0, color: Colors.black),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: hint,
                    contentPadding: EdgeInsets.only(bottom: 17),
                  ),
                  controller: _editControler,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  verifyle delete pateint
  Future<void> _showDialogDeletePatient(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xóa bệnh nhân khỏi danh sách'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có chắc chắn muốn xóa bệnh nhân này không?'),
                Text('nhấn "Yes" để xác nhận hoặc "No" để hủy yêu cầu'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                // DatabaseReference ref = FirebaseDatabase.instance.ref(
                //     "${widget.keyLogin!}/Users/${manager.getIdPatientIndexGroup(index)}");

                // path delete
                String tempPathID = manager.getIdPatientIndexGroup(index);
                manager.listInfomationGroup.removeAt(index);
                manager.listSelectedGroup.removeAt(index);

                // await ref.remove();

                if (manager.back_steps_selectGroup != -1)
                  manager.setSelecteDefautGroup();
                manager.back_steps_selectGroup = -1;

                await manager.upServerListInfoFireStore();
                await FirebaseFirestore.instance
                    .collection(keyCode!)
                    .doc('information_Pateint')
                    .update({'Users.$tempPathID': FieldValue.delete()})
                    .then((value) => print("User's Property Deleted"))
                    .catchError((error) =>
                        print("Failed to delete user's property: $error"));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _nextScreenHistoryPateint(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => new HistoryPateintScreen(
                checkGroupOrPersonal: true,
                manager: this.manager,
              )),
    );
  }
}
