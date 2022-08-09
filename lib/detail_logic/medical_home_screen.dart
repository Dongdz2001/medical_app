import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_app/authentication/login/home_screen.dart';
import 'package:medical_app/detail_logic/history_screen.dart';
import 'package:medical_app/detail_logic/medical_class.dart';
import 'package:medical_app/detail_logic/profile_info.dart';
import 'package:medical_app/detail_logic/sizeDevide.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:toast/toast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import "dart:async";

import '../manage_patient/patient.dart';

class MedicalHomeScreen extends StatefulWidget {
  final Patien? patienTemp;
  const MedicalHomeScreen({Key? key, required this.patienTemp})
      : super(key: key);

  @override
  State<MedicalHomeScreen> createState() => _MedicalHomeScreenState();
}

class _MedicalHomeScreenState extends State<MedicalHomeScreen>
    with WidgetsBindingObserver {
  late Medical medicalObject;
  // late AppLifecycleState _lastLifecycleState;
  final TextEditingController _editingController = TextEditingController();
  // get instancr firebase database
  final reference = FirebaseDatabase.instance.ref("Medicals/medical");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    medicalObject = widget.patienTemp?.getObjRegimen as Medical;
    WidgetsBinding.instance.addObserver(this);
  }

  // sava data when close app
  @override
  void dispose() {
    print("app was closed");
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused &&
        medicalObject.flagRestart == false) {
      // final reference = FirebaseDatabase.instance.ref("Medicals/medical");
      // await reference.set({
      //   "namePD": medicalObject.getNamePD,
      //   "initialStateBool": medicalObject.getInitialStateBool,
      //   "lastStateBool": medicalObject.getLastStateBool,
      //   "listResultInjection": medicalObject.getListResultInjection,
      //   "listTimeResultInjection": medicalObject.getListTimeResultInjection,
      //   "isVisibleGlucozo": medicalObject.isVisibleGlucozo,
      //   "isVisibleYesNoo": medicalObject.isVisibleYesNoo,
      //   "countUsedSolve": medicalObject.getCountUsedSolve,
      //   "timeStart": medicalObject.getTimeStart.toString(),
      //   "sloveFailedContext": medicalObject.getSloveFailedContext,
      //   "yInsu22H": medicalObject.getYInsu22H,
      //   "oldDisplayContent": medicalObject.oldDisplayContent,
      //   "flagRestart": medicalObject.flagRestart,
      //   //  "address": {"line1": "100 Mountain View"}
      // });
    }
    if (state != AppLifecycleState.detached) {
      setState(() => medicalObject.setStateInitial());
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff091a31),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: const BackButtonIcon(),
            ),
          ),
          body: FutureBuilder(
              future: medicalObject.readDataRealTimeDB("Medicals/medical"),
              builder: (context, snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  children = <Widget>[
                    SingleChildScrollView(
                      child: Container(
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0xfff5f6f6),
                            Colors.white,
                          ],
                        )),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // profile thông tin bệnh nhân
                            Row(
                              children: [
                                SizedBox(
                                  height: 90,
                                  width: 90,
                                  child: CircleAvatar(
                                    radius: 48, // Image radius
                                    backgroundImage: NetworkImage(
                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqkKsJE9otzQr3RAnkLRCThzaxfoJ0_6W2sg&usqp=CAU'),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 10, top: 5),
                                  height: 100,
                                  width: widthDevideMethod(0.6),
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(widget.patienTemp!.getName
                                          .toString()),
                                      Text(
                                        ' ${widget.patienTemp!.nameDisease != "None" ? widget.patienTemp!.nameDisease : "Bệnh?"}, ${widget.patienTemp!.getOld != null ? '${widget.patienTemp!.getOld} tuổi' : 'tuổi?'} , ${widget.patienTemp!.gender != 'unknow' ? widget.patienTemp!.gender : 'giới?'}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      SizedBox(
                                        height: heightDevideMethod(0.012),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: widthDevideMethod(0.03),
                                          ),
                                          // xem chi tiết thông tin bệnh nhân
                                          SizedBox(
                                            height: 30,
                                            child: ElevatedButton(
                                                onPressed: () =>
                                                    _navigateAndDisplaySelection(
                                                        context),
                                                child: Text('Xem chi tiết'),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color(0xff091a31),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                )),
                                          ),
                                          SizedBox(
                                            width: widthDevideMethod(0.05),
                                          ),
                                          //  Nhắn tin với bệnh nhân
                                          SizedBox(
                                            height: 30,
                                            child: ElevatedButton(
                                                onPressed: () {},
                                                child: Text('Nhắn tin'),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color(0xff091a31),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // Logic bác sĩ
                            Container(
                              padding:
                                  const EdgeInsets.only(bottom: 20, top: 20),
                              child: Text(
                                '${medicalObject.getNamePD}',
                                style: const TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    height: 1.5),
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
                                          height: heightDevideMethod(0.372),
                                        ),
                                        SizedBox(
                                            width: widthDevideMethod(0.7),
                                            child: Image.asset(
                                                "assets/doctor.jpg",
                                                fit: BoxFit.fitHeight)),
                                        Expanded(
                                            child: Container(
                                                height:
                                                    heightDevideMethod(0.372),
                                                color:
                                                    const Color(0xfff5f6f6))),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      right: 30,
                                      top: 20,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.info,
                                          color: Colors.grey[800],
                                          size: 40,
                                        ),
                                        tooltip:
                                            medicalObject.oldDisplayContent,
                                        onPressed: () {},
                                      )),
                                  Positioned(
                                    top: 120,
                                    left: 10,
                                    child: Container(
                                      alignment: Alignment.topCenter,
                                      width: widthDevideMethod(0.91),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image:
                                              AssetImage("assets/bbchat1.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              height: heightDevideMethod(0.03)),

                                          //  Bạn có đang tiêm Insulin không ?
                                          Row(
                                            children: [
                                              Container(
                                                width: widthDevideMethod(0.04),
                                              ),
                                              Text(
                                                '${medicalObject.getContentdisplay}  ',
                                                style: const TextStyle(
                                                    fontSize: 16),
                                                textAlign: TextAlign.left,
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8),
                                                alignment: Alignment.center,
                                                child: Visibility(
                                                  visible: medicalObject
                                                      .isVisibleYesNoo,
                                                  child: ToggleSwitch(
                                                    customWidths: const [
                                                      40.0,
                                                      50.0
                                                    ],
                                                    customHeights: const [
                                                      20,
                                                      20
                                                    ],
                                                    initialLabelIndex: 2,
                                                    cornerRadius: 20.0,
                                                    activeFgColor: Colors.white,
                                                    inactiveBgColor:
                                                        Colors.grey,
                                                    inactiveFgColor:
                                                        Colors.white,
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
                                                      medicalObject
                                                          .flagRestart = false;
                                                      medicalObject
                                                              .setTimeStart =
                                                          DateTime.now()
                                                              .toString()
                                                              .substring(0, 16);
                                                      print(medicalObject
                                                          .getTimeStart);
                                                      medicalObject
                                                              .isVisibleGlucozo =
                                                          !medicalObject
                                                              .isVisibleGlucozo;
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  500), () {
                                                        setState(() {
                                                          medicalObject
                                                                  .isVisibleYesNoo =
                                                              false;
                                                          medicalObject
                                                                  .setInitialStateBool =
                                                              index == 0
                                                                  ? true
                                                                  : false;
                                                          medicalObject
                                                              .setStateInitial();
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
                                  Positioned(
                                    top: 20,
                                    left: 10,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.restart_alt_rounded,
                                        size: 35,
                                      ),
                                      tooltip: 'restart',
                                      onPressed: () => _showMyDialog(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: medicalObject.isVisibleGlucozo,
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
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[0-9.]')),
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
                                            builder: (context) => HistoryScreen(
                                                medical: medicalObject))),
                                    child: const Icon(
                                      Icons.history,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: heightDevideMethod(0.02)),
                          ],
                        ),
                      ),
                    )
                  ];
                } else if (snapshot.hasError) {
                  children = <Widget>[
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${snapshot.error}'),
                    )
                  ];
                } else {
                  children = const <Widget>[
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
                }
                return snapshot.hasData
                    ? SingleChildScrollView(
                        child: SafeArea(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: children,
                          ),
                        ),
                      )
                    : Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: children,
                          ),
                        ),
                      );
              })),
      onWillPop: () async {
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => Home()));
        return true;
      },
    );
  }

  // xử lý logic
  Future<void> _logicStateInfomation(String value) async {
    setState(() {
      medicalObject.addItemListResultInjectionItem(
          value); // double.parse(value.toString())
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
              medicalObject.setOldDisplayContent();
              medicalObject.setContentdisplay =
                  """Phương án hiện tại không đạt yêu cầu \n nên thêm ${medicalObject.getSloveFailedContext}""";

              medicalObject.upCountUsedSolve();
              medicalObject.resetInjectionValueDefault();
              Future.delayed(const Duration(seconds: 8), (() {
                setState(() {
                  medicalObject.setStateInitial();
                });
              }));
              // không tiêm Insulin không đạt mục tiêu lần 2
            } else if (medicalObject.getCountUsedSolve == 1) {
              medicalObject.setOldDisplayContent();
              medicalObject.setContentdisplay =
                  "Phương án hiện tại không đạt yêu cầu \n chuyển sang 1 phương án khác !";
              medicalObject.downCountUsedSolve();
              medicalObject.setInitialStateBool =
                  !medicalObject.getInitialStateBool;
              medicalObject.resetInjectionValueDefault();
              Future.delayed(const Duration(seconds: 8), (() {
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
                medicalObject.setOldDisplayContent();
                medicalObject.setContentdisplay =
                    """Phương án hiện tại không đạt yêu cầu \n nên thêm ${medicalObject.getSloveFailedContext}""";
                medicalObject.upCountUsedSolve();
                medicalObject.resetInjectionValueDefault();
                Future.delayed(const Duration(seconds: 6), (() {
                  setState(() {
                    medicalObject.setStateInitial();
                  });
                }));
              } else if (medicalObject.getCountUsedSolve == 1) {
                medicalObject.setOldDisplayContent();
                medicalObject.setContentdisplay =
                    "Phương án hiện tại không đạt yêu cầu \n cần tăng liều Lantus lên 2UI !";
                medicalObject.downCountUsedSolve();
                medicalObject.setYInsu22H(2);
                medicalObject.setLastStateBool = true;
                medicalObject.resetInjectionValueDefault();
                Future.delayed(const Duration(seconds: 6), (() {
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
                medicalObject.setOldDisplayContent();
                medicalObject.setContentdisplay =
                    """Phương án hiện tại không đạt yêu cầu \n nên thêm ${medicalObject.getSloveFailedContext}""";
                medicalObject.resetInjectionValueDefault();
                Future.delayed(const Duration(seconds: 6), (() {
                  setState(() {
                    medicalObject.setStateInitial();
                  });
                }));
              } else if (medicalObject.getCountUsedSolve == 1) {
                medicalObject.setOldDisplayContent();
                medicalObject.setContentdisplay =
                    "Phác đồ này không đạt hiểu quả \n hãy chuyển sang phác đồ \n TRUYỀN INSULIN BƠM TIÊM ĐIỆN ";
                // medicalObject.resetAllvalueIinitialStatedefaut();
              }
            }
          }
        } else if (medicalObject.getCheckPassInjection() == 1) {
          medicalObject.setOldDisplayContent();
          medicalObject.setContentdisplay =
              "Phương án này đang có hiệu quả tốt \n tiếp tục sử dụng phương án này nhé !";
          Future.delayed(const Duration(seconds: 6), (() {
            setState(() {
              medicalObject.setStateInitial();
            });
          }));
          medicalObject.resetInjectionValueDefault();
        }
      }
    });
  }

  // show toast infomation
  void showToast(String msg, {int? duration, int? gravity}) {
    Toast.show(msg, duration: duration, gravity: gravity);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Khôi phục mặc định'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Dữ liệu sẽ bị xóa toàn bộ về trạng thái ban đầu '),
                Text('Bạn có chắc chắn không ?'),
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
              onPressed: () {
                setState(() {
                  medicalObject.flagRestart = true;
                  medicalObject.removeDataBase("Medicals/medical");
                  medicalObject.resetAllvalueIinitialStatedefaut();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(
          builder: (context) => ProfileInfo(patienTemp: widget.patienTemp)),
    );
    try {
      if (result) {
        setState(() {});
      }
    } catch (e) {
      print("null pop error");
    }
  }
}
