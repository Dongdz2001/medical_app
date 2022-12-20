import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/manage_patient/manager.dart';

import '../NDDTM_medical/medical_home_screen.dart';
import '../manage_patient/patient.dart';

class HistoryPateintScreen extends StatefulWidget {
  final Manager? manager;
  final bool? checkGroupOrPersonal;
  const HistoryPateintScreen(
      {Key? key, required this.checkGroupOrPersonal, required this.manager})
      : super(key: key);

  @override
  _HistoryPateintScreenState createState() => _HistoryPateintScreenState();
}

class _HistoryPateintScreenState extends State<HistoryPateintScreen> {
  late Manager manager;
  late bool _checkGroupOrPersonal;
  final ScrollController _controllerScroll = ScrollController();
  final items = [
    'Nuôi dưỡng đường tĩnh mạch',
    'Nuôi cấy tế bào gốc',
    'Điều trị đau vai gáy'
  ];

  @override
  void initState() {
    // TODO: implement initState
    _checkGroupOrPersonal = this.widget.checkGroupOrPersonal!;
    manager = this.widget.manager!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Patien patien = Patien(name: "None", veryfileID: "None");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff091a31),
        title: Text(_checkGroupOrPersonal
            ? 'Lịch sử lưu trữ nhóm'
            : 'Lịch sử lưu trữ cá nhân'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListView.builder(
              itemCount: _checkGroupOrPersonal
                  ? ((manager.listHistoryInfomationGroup.length != 0)
                      ? manager.listHistoryInfomationGroup.length
                      : 0)
                  : ((manager.listHistoryInfomation.length != 0)
                      ? manager.listHistoryInfomation.length
                      : 0),
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
                    color: Colors.white,
                    shadowColor: Colors.blueAccent,
                    // ListTile Event
                    child: ListTile(
                      onTap: () async {
                        patien.name = _checkGroupOrPersonal
                            ? manager.getNameHistoryInfoPateintIndexGroup(index)
                            : manager.getNameHistoryInfoPateintIndex(index);
                        patien.setID = _checkGroupOrPersonal
                            ? manager.getIdHistoryPateintIndexGroup(index)
                            : manager.getIdHistoryPateintIndex(index);

                        _checkGroupOrPersonal
                            ? await patien.readDataFireStoreDB(
                                manager.keyCodeGroup!,
                                'Users.${manager.getIdHistoryPateintIndexGroup(index)}')
                            : await patien.readDataRealTimeDB(
                                "${manager.keyLogin}/Users/${manager.getIdHistoryPateintIndex(index)}");

                        setState(() {
                          _navigateAndDisplaySelection(context, index, patien);
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
                        _checkGroupOrPersonal
                            ? manager.getNameHistoryInfoPateintIndexGroup(index)
                            : manager.getNameHistoryInfoPateintIndex(index),
                        // manager.getList()![index].getName,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                      // Hien thi Phác đồ duoi ten benh nhan
                      subtitle: // Chọn phác đồ
                          Padding(
                        padding: const EdgeInsets.only(right: 40),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 8),
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.black, width: 1),
                              ),
                              child: DropdownButton<String>(
                                value: patien.getRegimen,
                                isExpanded: true,
                                items: items.map(buildMenuItem).toList(),
                                onChanged: (val) => setState(() {
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
    );
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

  Future<void> _navigateAndDisplaySelection(
      BuildContext context, int index, Patien patien) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => MedicalHomeScreen(
                  checkGroupOrPerSonal: _checkGroupOrPersonal,
                  patienTemp: patien,
                  index: index,
                ))));
    try {
      if (result) {
        setState(() {});
      }
    } catch (e) {
      print("null pop error");
    }
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
                if (_checkGroupOrPersonal) {
                  String tempPathID =
                      manager.getIdHistoryPateintIndexGroup(index);
                  await FirebaseFirestore.instance
                      .collection(manager.keyCodeGroup!)
                      .doc('information_Pateint')
                      .update({'Users.$tempPathID': FieldValue.delete()})
                      .then((value) => print("User's Property Deleted"))
                      .catchError((error) =>
                          print("Failed to delete user's property: $error"));

                  if (manager.back_steps_selectGroup != -1)
                    manager.setSelecteDefautGroup();
                  manager.back_steps_selectGroup = -1;

                  setState(
                      () => manager.listHistoryInfomationGroup.removeAt(index));
                  await manager.upServerListInfoFireStore();
                } else {
                  DatabaseReference refe = FirebaseDatabase.instance.ref(
                      "${manager.keyLogin!}/Users/${manager.getIdHistoryPateintIndex(index)}");
                  setState(() => manager.listHistoryInfomation.removeAt(index));
                  manager.upSeverListInfo();
                  await refe.remove();
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
