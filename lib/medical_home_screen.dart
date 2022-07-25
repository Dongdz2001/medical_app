import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_app/controller_time.dart';
import 'package:medical_app/history_screen.dart';
import 'package:medical_app/medical_class.dart';
import 'package:medical_app/sizeDevide.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:toast/toast.dart';
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
  TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 20, top: 20),
            child: Text(
              '${medicalObject.getNamePD}',
              style: TextStyle(
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
                      SizedBox(
                        width: widthDevideMethod(0.1),
                      ),
                      SizedBox(
                          width: widthDevideMethod(0.7),
                          child: Image.asset("assets/doctor.jpg",
                              fit: BoxFit.fitHeight)),
                      Expanded(child: Container(color: Color(0xfff5f6f6))),
                    ],
                  ),
                ),
                Positioned(
                  top: 120,
                  left: 10,
                  child: Container(
                    alignment: Alignment.topCenter,
                    width: widthDevideMethod(0.91),
                    padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
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
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.left,
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 8),
                              alignment: Alignment.center,
                              child: Visibility(
                                visible: _isVisibleYesNoo,
                                child: ToggleSwitch(
                                  customWidths: [40.0, 50.0],
                                  customHeights: [20, 20],
                                  initialLabelIndex: 2,
                                  cornerRadius: 20.0,
                                  activeFgColor: Colors.white,
                                  inactiveBgColor: Colors.grey,
                                  inactiveFgColor: Colors.white,
                                  totalSwitches: 2,
                                  fontSize: 14,
                                  labels: ['No', 'Yes'],
                                  //Icons.backspace_rounded, Icons.add_task_rounded
                                  // icons: [
                                  //   Icons.backspace_rounded,
                                  //   Icons.add_task_rounded
                                  // ],
                                  activeBgColors: [
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
                                            Duration(seconds: 10), (Timer t) {
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
                Container(
                  width: 80,
                  height: 40,
                  child: TextField(
                    controller: _editingController,
                    maxLength: 5,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                    ],
                    decoration: InputDecoration(
                      counter: Offstage(),
                    ),
                    style: TextStyle(fontSize: 20),
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
                  child: Icon(
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
            child: Text(
              'Thông tin bệnh nhân: ',
              style: TextStyle(fontSize: 20),
            ),
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
          Duration(seconds: 1),
          (() => showToast(
              "Nồng độ Glucozo ${value} ${medicalObject.getCheckGlucozo(double.parse(value.toString())) ? "đạt mục tiêu" : "KHÔNG đạt mục tiêu"} ",
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
              Future.delayed(Duration(seconds: 10), (() {
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
              Future.delayed(Duration(seconds: 10), (() {
                setState(() {
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

                medicalObject.resetInjectionValueDefault();
                Future.delayed(Duration(seconds: 10), (() {
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
                Future.delayed(Duration(seconds: 6), (() {
                  setState(() {
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
                Future.delayed(Duration(seconds: 6), (() {
                  setState(() {
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
}
