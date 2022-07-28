import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_app/history_screen.dart';
import 'package:medical_app/medical_class.dart';
import 'package:medical_app/sizeDevide.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:toast/toast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import "dart:async";

class MedicalHomeScreen extends StatefulWidget {
  const MedicalHomeScreen({Key? key}) : super(key: key);

  @override
  State<MedicalHomeScreen> createState() => _MedicalHomeScreenState();
}

class _MedicalHomeScreenState extends State<MedicalHomeScreen> {
  bool _isVisibleGlucozo = false;
  bool _isVisibleYesNoo = true;
  bool _flagTimer = true;
  Medical medicalObject = Medical();
  final TextEditingController _editingController = TextEditingController();

  // new add Controller HP
  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final gluController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 20, top: 20),
            child: Text(
              '${medicalObject.getNamePD}',
              style: const TextStyle(
                  fontSize: 23, fontWeight: FontWeight.bold, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            height: heightDevideMethod(0.42),
            child: Stack(
              children: [
                SizedBox(
                  height: heightDevideMethod(0.4),
                  child: Row(
                    children: [
                      Container(
                        color: Colors.white,
                        width: widthDevideMethod(0.1),
                        height: heightDevideMethod(0.37),
                      ),
                      SizedBox(
                          width: widthDevideMethod(0.7),
                          child: Image.asset("assets/doctor.jpg",
                              fit: BoxFit.fitHeight)),
                      Expanded(
                          child: Container(color: const Color(0xfff5f6f6))),
                    ],
                  ),
                ),
                Positioned(
                  top: 120,
                  left: 10,
                  child: Container(
                    alignment: Alignment.topCenter,
                    width: widthDevideMethod(0.91),
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/bbchat1.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: heightDevideMethod(0.03)),

                        //  Bạn có đang tiêm Insulin không ?
                        Row(
                          children: [
                            Container(
                              width: widthDevideMethod(0.04),
                            ),
                            Text(
                              '${medicalObject.getContentdisplay}  ',
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.left,
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              alignment: Alignment.center,
                              child: Visibility(
                                visible: _isVisibleYesNoo,
                                child: ToggleSwitch(
                                  customWidths: const [40.0, 50.0],
                                  customHeights: const [20, 20],
                                  initialLabelIndex: 2,
                                  cornerRadius: 20.0,
                                  activeFgColor: Colors.white,
                                  inactiveBgColor: Colors.grey,
                                  inactiveFgColor: Colors.white,
                                  totalSwitches: 2,
                                  fontSize: 14,
                                  labels: const ['No', 'Yes'],
                                  //Icons.backspace_rounded, Icons.add_task_rounded
                                  // icons: [
                                  //   Icons.backspace_rounded,
                                  //   Icons.add_task_rounded
                                  // ],
                                  activeBgColors: const [
                                    [Colors.pink],
                                    [Colors.green]
                                  ],
                                  onToggle: (index) {
                                    medicalObject.setTimeStart = DateTime.now()
                                        .toString()
                                        .substring(0, 16);
                                    print(medicalObject.getTimeStart);
                                    _isVisibleGlucozo = !_isVisibleGlucozo;
                                    Future.delayed(
                                        const Duration(milliseconds: 500), () {
                                      setState(() {
                                        _isVisibleYesNoo = false;
                                        medicalObject.setInitialStateBool =
                                            index == 0 ? true : false;
                                        medicalObject.setStateInitial();
                                        Timer timer = Timer.periodic(
                                            const Duration(seconds: 10),
                                            (Timer t) {
                                          if (_flagTimer) {
                                            setState(() {
                                              medicalObject.setStateInitial();
                                            });
                                          }
                                        });
                                      });
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: _isVisibleGlucozo,
            child: Row(
              children: [
                SizedBox(width: widthDevideMethod(0.05)),
                const Text(
                  ' Nồng độ glucozơ : ',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 80,
                  height: 40,
                  child: TextField(
                    controller: _editingController,
                    maxLength: 5,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                    ],
                    decoration: const InputDecoration(
                      counter: Offstage(),
                    ),
                    style: const TextStyle(fontSize: 20),
                    onSubmitted: (value) {
                      _logicStateInfomation(value);
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HistoryScreen(medical: medicalObject))),
                  child: const Icon(
                    Icons.history,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: heightDevideMethod(0.02)),
          Container(
            color: Colors.amberAccent,
            child: const Text(
              'Thông tin bệnh nhân: ',
              style: TextStyle(fontSize: 20),
            ),
          ),

          // Add information of HP
          Column(
            children: [
              SizedBox(
                height: heightDevideMethod(0.02),
              ),
              TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  )),
              SizedBox(
                height: heightDevideMethod(0.02),
              ),
              TextFormField(
                  controller: genderController,
                  decoration: InputDecoration(
                    labelText: 'Giới tính',
                    border: OutlineInputBorder(),
                  )),
              SizedBox(
                height: heightDevideMethod(0.02),
              ),
              TextFormField(
                  controller: ageController,
                  decoration: InputDecoration(
                    labelText: 'Năm Sinh',
                    border: OutlineInputBorder(),
                  )),
              SizedBox(
                height: heightDevideMethod(0.02),
              ),
              TextFormField(
                  controller: heightController,
                  decoration: InputDecoration(
                    labelText: 'Chiều cao',
                    border: OutlineInputBorder(),
                  )),
              SizedBox(
                height: heightDevideMethod(0.02),
              ),
              TextFormField(
                  controller: weightController,
                  decoration: InputDecoration(
                    labelText: 'Cân nặng',
                    border: OutlineInputBorder(),
                  )),
              SizedBox(
                height: heightDevideMethod(0.02),
              ),
              TextFormField(
                  controller: gluController,
                  decoration: InputDecoration(
                    labelText: 'Glu mmol/l',
                    border: OutlineInputBorder(),
                  )),
              SizedBox(
                height: heightDevideMethod(0.02),
              ),
              OutlinedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      ageController.text.isNotEmpty &&
                      genderController.text.isNotEmpty &&
                      heightController.text.isNotEmpty &&
                      weightController.text.isNotEmpty &&
                      gluController.text.isNotEmpty) {
                    insertData(
                        nameController.text,
                        genderController.text,
                        ageController.text,
                        heightController.text,
                        weightController.text,
                        gluController.text);
                  }
                },
                child: Text('Add', style: TextStyle(fontSize: 18)),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _logicStateInfomation(String value) async {
    setState(() {
      medicalObject
          .addItemListResultInjectionItem(double.parse(value.toString()));
      _editingController.text = "";
      Future.delayed(
          const Duration(seconds: 1),
          (() => showToast(
              "Nồng độ Glucozo $value ${medicalObject.getCheckGlucozo(double.parse(value.toString())) ? "đạt mục tiêu" : "KHÔNG đạt mục tiêu"} ",
              duration: 3,
              gravity: Toast.bottom)));
      if (medicalObject.getCountInject() >= 4) {
        if (medicalObject.getCheckPassInjection() == 0) {
          // Trường hợp không tiêm Insulin không đạt mục tiêu
          if (medicalObject.getInitialStateBool) {
            // ko tiêm Insulin không đạt mục tiêu lần 1
            if (medicalObject.getCountUsedSolve == 0) {
              medicalObject.set_Content_State_Check_Gluco_Failed(
                  medicalObject.getLastFaildedResultValue());
              medicalObject.setContentdisplay =
                  """Phương án hiện tại không đạt yêu cầu \n nên thêm ${medicalObject.getSloveFailedContext}""";
              medicalObject.upCountUsedSolve();
              medicalObject.resetInjectionValueDefault();
              Future.delayed(const Duration(seconds: 10), (() {
                setState(() {
                  medicalObject.setStateInitial();
                });
              }));
              // không tiêm Insulin không đạt mục tiêu lần 2
            } else if (medicalObject.getCountUsedSolve == 1) {
              medicalObject.setContentdisplay =
                  "Phương án hiện tại không đạt yêu cầu \n chuyển sang 1 phương án khác !";
              medicalObject.downCountUsedSolve();
              medicalObject.setInitialStateBool =
                  !medicalObject.getInitialStateBool;
              medicalObject.resetInjectionValueDefault();
              _flagTimer = !_flagTimer;
              Future.delayed(const Duration(seconds: 10), (() {
                setState(() {
                  _flagTimer = !_flagTimer;
                  medicalObject.setStateInitial();
                });
              }));
            }
          } else {
            // Phương án tiêm insulin không đạt mục tiêu
            if (!medicalObject.getLastStateBool) {
              //  tiêm Insulin không đạt mục tiêu lần 1
              if (medicalObject.getCountUsedSolve == 0) {
                medicalObject.set_Content_State_Check_Gluco_Failed(
                    medicalObject.getLastFaildedResultValue());
                medicalObject.setContentdisplay =
                    """Phương án hiện tại không đạt yêu cầu \n nên thêm ${medicalObject.getSloveFailedContext}""";
                medicalObject.upCountUsedSolve();
                _flagTimer = !_flagTimer;
                medicalObject.resetInjectionValueDefault();
                Future.delayed(const Duration(seconds: 6), (() {
                  _flagTimer = !_flagTimer;
                  setState(() {
                    medicalObject.setStateInitial();
                  });
                }));
              } else if (medicalObject.getCountUsedSolve == 1) {
                medicalObject.setContentdisplay =
                    "Phương án hiện tại không đạt yêu cầu \n cần tăng liều Lantus lên 2UI !";
                medicalObject.downCountUsedSolve();
                medicalObject.setYInsu22H(2);
                medicalObject.setLastStateBool = true;
                medicalObject.resetInjectionValueDefault();
                _flagTimer = !_flagTimer;
                Future.delayed(const Duration(seconds: 6), (() {
                  setState(() {
                    _flagTimer = !_flagTimer;
                    medicalObject.setStateInitial();
                  });
                }));
              }
            } else {
              // Phương án cuối cùng tăng liều 2UI Lantus
              if (medicalObject.getCountUsedSolve == 0) {
                medicalObject.upCountUsedSolve();
                medicalObject.set_Content_State_Check_Gluco_Failed(
                    medicalObject.getLastFaildedResultValue());
                medicalObject.setContentdisplay =
                    """Phương án hiện tại không đạt yêu cầu \n nên thêm ${medicalObject.getSloveFailedContext}""";
                medicalObject.resetInjectionValueDefault();
                _flagTimer = !_flagTimer;
                Future.delayed(const Duration(seconds: 6), (() {
                  setState(() {
                    _flagTimer = !_flagTimer;
                    medicalObject.setStateInitial();
                  });
                }));
              } else if (medicalObject.getCountUsedSolve == 1) {
                medicalObject.setContentdisplay =
                    "Phác đồ này không đạt hiểu quả \n hãy chuyển sang phác đồ \n TRUYỀN INSULIN BƠM TIÊM ĐIỆN ";
                medicalObject.resetAllvalueIinitialStatedefaut();
                setState(() {
                  _flagTimer = false;
                });
              }
            }
          }
        } else if (medicalObject.getCheckPassInjection() == 1) {
          medicalObject.setContentdisplay =
              "Phương án này đang có hiệu quả tốt \n tiếp tục sử dụng phương án này nhé !";
          medicalObject.resetInjectionValueDefault();
        }
      }
    });
  }

  // show toast infomation
  void showToast(String msg, {int? duration, int? gravity}) {
    Toast.show(msg, duration: duration, gravity: gravity);
  }

  //  Insert Data of Hoang Phan
  Future<void> insertData(String name, String gender, String age, String height,
      String weight, String glu) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/163");
    await ref.set({
      "name": "John",
      "age": 18,
      "address": {"line1": "100 Mountain View"}
    });
    // String? key = databaseRef.child('Users').push().key;
    // databaseRef.child('Users').child(key!).set({
    //   'id': key,
    //   'name': name,
    //   'gender': gender,
    //   'age': age,
    //   'height': height,
    //   'weight': weight,
    //   'glu': glu
    // });
    // nameController.clear();
    // genderController.clear();
    // ageController.clear();
    // heightController.clear();
    // weightController.clear();
    // gluController.clear();
    final ref1 = FirebaseDatabase.instance.ref();
    final snapshot = await ref1.child('users/123').get();
    var value = Map<String, dynamic>.from(snapshot.value as Map);
    var title = value["age"];
    if (snapshot.exists) {
      print(value);
    } else {
      print('No data available.');
    }
  }
}
