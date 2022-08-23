import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
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
import 'controller_time.dart';

class MedicalHomeScreen extends StatefulWidget {
  final Patien? patienTemp;
  final int? index;

  const MedicalHomeScreen(
      {Key? key, required this.patienTemp, required this.index})
      : super(key: key);

  @override
  State<MedicalHomeScreen> createState() => _MedicalHomeScreenState();
}

class _MedicalHomeScreenState extends State<MedicalHomeScreen>
    with WidgetsBindingObserver {
  late Medical medicalObject;
  late Patien patien;
  late int index;
  // late AppLifecycleState _lastLifecycleState;
  final TextEditingController _editingController = TextEditingController();
  final TextEditingController _enterWeightController = TextEditingController();
  // get instancr firebase database
  late final reference;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    patien = widget.patienTemp!;
    index = widget.index!;
    medicalObject = widget.patienTemp?.getObjRegimen as Medical;
    reference = FirebaseDatabase.instance.ref(
        "${widget.patienTemp!.keyLogin}/Users/${widget.patienTemp!.getID}/Medical");
    WidgetsBinding.instance.addObserver(this);
  }

  // sava data when close app
  @override
  void dispose() {
    if (medicalObject.flagRestart == false) {
      medicalObject
          .saveData("${patien.keyLogin}/Users/${patien.getID}/Medical");
    }
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused &&
        medicalObject.flagRestart == false) {
      medicalObject.saveData(
          "${widget.patienTemp!.keyLogin}/Users/${widget.patienTemp!.getID}/Medical");
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
                if (medicalObject.flagRestart == false)
                  medicalObject.saveData(
                      "${widget.patienTemp!.keyLogin}/Users/${widget.patienTemp!.getID}/Medical");
                Navigator.pop(context, true);
              },
              icon: const BackButtonIcon(),
            ),
          ),
          body: FutureBuilder(
              future: medicalObject.readDataRealTimeDB(
                  "${widget.patienTemp!.keyLogin}/Users/${widget.patienTemp!.getID}/Medical"),
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
                                                        context, index),
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
                                        tooltip: "history",
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HistoryScreen(
                                                          medical:
                                                              medicalObject)));
                                        },
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
                                              Flexible(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 5),
                                                  child: Text(
                                                    '${medicalObject.getContentdisplay}  ',
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
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
                                                          .timeNextCurrentValid();
                                                      medicalObject
                                                          .flagRestart = false;
                                                      medicalObject
                                                              .setTimeStart =
                                                          DateTime.now()
                                                              .toString()
                                                              .substring(0, 16);
                                                      print(medicalObject
                                                          .getTimeStart);
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
                                                          if (medicalObject
                                                              .checkValidMeasuringTimeFocus()) {
                                                            medicalObject
                                                                .setChangeVisibleGlucose(); // true
                                                            medicalObject
                                                                .setChangeCheckCurrentGlucose(); // true
                                                          } else {
                                                            // print("here jump!");
                                                            medicalObject
                                                                .setChangeVisibleButtonNext(); // true
                                                          }
                                                          print(
                                                              "check currrnt ${medicalObject.checkCurrentGlucose}");
                                                          medicalObject
                                                              .setChangeStatus();
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
                            // Nút chuyển tiếp phương án
                            Visibility(
                              visible: medicalObject.isVisibleButtonNext,
                              child: ElevatedButton(
                                  onPressed: () {
                                    print(
                                        "timeNext == ${medicalObject.timeNext}");
                                    //  update time TimeNextDay  trước khi tiến hành
                                    if (medicalObject
                                        .checkSmallerTimeNextDay()) {
                                      medicalObject.timeNextDay =
                                          DateFormat('dd-MM-yyyy').format(
                                              DateTime
                                                  .now()); // update time day
                                    }
                                    if (medicalObject.checkTimeNextDay()) {
                                      if (medicalObject
                                              .checkValidMeasuringTimeFocus() &&
                                          medicalObject.checkTimeNext()) {
                                        if (!medicalObject
                                            .checkCurrentGlucose) {
                                          if (!medicalObject.checkDoneTask) {
                                            // chưa nhập glucose xong
                                            setState(() {
                                              medicalObject
                                                  .setChangeVisibleButtonNext(); // ẩn nút
                                              medicalObject
                                                  .setChangeVisibleGlucose(); // hiện nhập glucose
                                              medicalObject
                                                  .setChangeCheckCurrentGlucose(); // đã tới bước nhập glucose
                                              print("Time tiep theo:" +
                                                  medicalObject.timeNext);
                                            });
                                          } else {
                                            // kiểm tra time next hợp lệ không
                                            if (medicalObject.checkTimeNext()) {
                                              medicalObject.checkDoneTask =
                                                  false;
                                              medicalObject
                                                  .setChangeVisibleButtonNext(); // ẩn nút // = false
                                              medicalObject
                                                  .setChangeVisibleGlucose(); // hiện nhập glucose // = true
                                              medicalObject
                                                  .setChangeCheckCurrentGlucose(); // đã tới bước nhập glucose // = true
                                            }
                                            if (medicalObject.checkDoneTask) {
                                              showToast("Chưa đến giờ đo ",
                                                  duration: 3,
                                                  gravity: Toast.bottom);
                                            }
                                          }
                                        } else {
                                          showToast("Chưa đến giờ đo hihi",
                                              duration: 3,
                                              gravity: Toast.bottom);
                                        }
                                      } else {
                                        setState(() {
                                          medicalObject.checkDoneTask = true;
                                          medicalObject.setChangeStatus();
                                          medicalObject.checkDoneTask = false;

                                          showToast("Chưa đến giờ đo hihiiaaaa",
                                              duration: 3,
                                              gravity: Toast.bottom);
                                        });
                                      }
                                      if (medicalObject.getContentdisplay !=
                                              medicalObject
                                                  .delaySolution1DayAt22h &&
                                          medicalObject.checkTimeNext()) {
                                        setState(() {
                                          medicalObject.setChangeStatus();
                                        });
                                      } else {
                                        if (medicalObject.checkTimeNext()) {
                                          setState(() {
                                            medicalObject.setChangeStatus();
                                          });
                                        }
                                      }
                                    } else {
                                      showToast("Chưa đến giờ đo ",
                                          duration: 3, gravity: Toast.bottom);
                                    }
                                  },
                                  child: const Text('Chuyển tiếp >>>')),
                            ),

                            // Hiện nhập glucose
                            Visibility(
                              visible: medicalObject.isVisibleGlucose,
                              child: Column(
                                children: [
                                  SizedBox(width: widthDevideMethod(0.05)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        ' Nhập giá trị (mol/l) : ',
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
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp('[0-9.]')),
                                          ],
                                          decoration: const InputDecoration(
                                            counter: Offstage(),
                                          ),
                                          style: const TextStyle(fontSize: 20),
                                          onSubmitted: (value) {
                                            _editingController.text = '';
                                            _showDialogInputGlucose(value);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Hiện nhập Cân nặng hiện tại
                            Visibility(
                              visible: medicalObject.isVisibleWeight &&
                                  !medicalObject.getInitialStateBool,
                              child: Column(
                                children: [
                                  SizedBox(width: widthDevideMethod(0.05)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        ' Nhập cân nặng(Kg) : ',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        width: 80,
                                        height: 40,
                                        child: TextField(
                                          controller: _enterWeightController,
                                          maxLength: 5,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp('[0-9.]')),
                                          ],
                                          decoration: const InputDecoration(
                                            counter: Offstage(),
                                          ),
                                          style: const TextStyle(fontSize: 20),
                                          onSubmitted: (value) {
                                            _editingController.text = '';
                                            _showDialogInputWeight(value);
                                          },
                                        ),
                                      ),
                                    ],
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
                  medicalObject.removeDataBase(
                      "${widget.patienTemp!.keyLogin}/Users/${widget.patienTemp!.getID}/Medical");
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

  //  verifyle kết quả  đo GLucose
  Future<void> _showDialogInputGlucose(String value) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Đường máu mao mạch'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Giá trị bạn nhập vào là ${value}'),
                Text('nhấn "Yes" để xác nhận chính xác hoặc "No" để nhập lại'),
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
                  this._logicStateInfomation(value);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //  verifyle kết quả  đo Cân Nặng
  Future<void> _showDialogInputWeight(String value) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cân nặng hiện tại'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Giá trị bạn nhập vào là ${value}'),
                Text('nhấn "Yes" để xác nhận chính xác hoặc "No" để nhập lại'),
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
                  medicalObject
                      .setChangeVisibleWeight(); // ẩn thanh nhập cân nặng = false
                  medicalObject
                      .setYInsu22H(double.parse(value)); // thay đổi liểu UI
                  medicalObject
                      .setChangeVisibleButtonNext(); // hiện nút chuyển tiếp = true
                  medicalObject.setChangeStatus(); // thay đổi trạng thái
                  medicalObject.setChangeCheckDoneTask(); // done task = true
                  medicalObject.timeNextValid(); // dỏne
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // xử lý logic
  Future<void> _logicStateInfomation(String value) async {
    medicalObject
        .addItemListResultInjectionItem(value); // add data  list  kết quả đo
    if (medicalObject.getCountInject() >= 4) {
      if (medicalObject.getCheckPassInjection() == 0) {
        // chuyển đổi phương án
        if (medicalObject.getInitialStateBool) {
          medicalObject.setInitialStateBool =
              false; // chuyển từ ko tiêm Insulin sang tiêm Insulin
        } else if (!medicalObject.getLastStateBool) {
          medicalObject.setLastStateBool = true; //  chuyển phương án cuối
        } else {
          // kết thúc phác đồ
          setState(() {
            medicalObject.checkBreak = true;
            medicalObject.setContentdisplay =
                "Phác đồ này không khả dụng nữa, hãy sử dụng một phác đô khác hiệu quả hơn";
            medicalObject.setChangeVisibleGlucose(); // ân nhaập glucose
          });
        }
        if (!medicalObject.checkBreak) {
          //  xóa lịch sử đo
          medicalObject.resetInjectionValueDefault();
          // add label vào list history
          medicalObject.addLabelDatatoListHistoryFailed();
          // kiểm tra xem có thất bại lúc 22h không để chờ 1 ngày
          if (getCheckOpenCloseTimeStatus('22:00', '22:30')) {
            medicalObject.updateTimeNextDay();
            medicalObject.setDelaySolution1DayAt22h();
            medicalObject
                .setChangeVisibleButtonNext(); // hiện lại nút next // = flase
            medicalObject
                .setChangeVisibleGlucose(); // ẩn thanh nhập glucose // = false
            medicalObject.setChangeCheckCurrentGlucose(); // qua bước nhập =true
            medicalObject
                .setChangeCheckDoneTask(); // đã hiển thị phương án // true
            medicalObject.timeNext = '22:00_22:30';
          } else {
            medicalObject.addItemListHistory(value);
          }
        }
      } else if (medicalObject.getCheckPassInjection() == 1) {
        medicalObject.resetInjectionValueDefault();
      } else {
        medicalObject.addItemListHistory(value); // add data to history
      }
    } else {
      medicalObject.addItemListHistory(value); // add data to history
    }

    // check dừng phác đô
    if (!medicalObject.checkBreak) {
      // kiểm tra xem đúng  ngày không
      if (medicalObject.checkTimeNextDay() && medicalObject.checkTimeNext()) {
        // Hiển thị phác độ theo giờ
        if (!getCheckOpenCloseTimeStatus('22:00', '22:30') ||
            medicalObject.getInitialStateBool) {
          setState(() {
            // double.parse(value.toString())

            medicalObject
                .setChangeCheckCurrentGlucose(); // nhập xong hiện phác đồ // = flase
            if (!medicalObject.isVisibleButtonNext)
              medicalObject
                  .setChangeVisibleButtonNext(); // hiện lại nút next // flase
            medicalObject
                .setChangeVisibleGlucose(); //  ẩn thanh nhập Glucose // flase
            medicalObject.setChangeStatus(); // thay đổi trạng thái
            medicalObject.setChangeCheckDoneTask(); // đã hiện phác đồ // true
            medicalObject.timeNextValid();
            print("timeNext = ${medicalObject.timeNext}");
          });
        } else {
          setState(() {
            medicalObject.timeNextValid();
            medicalObject
                .setChangeVisibleGlucose(); // ẩn thanh nhập Glucose = false
            medicalObject
                .setChangeVisibleWeight(); // hiện thanh nhập Cân nặng = True
            medicalObject
                .setChangeCheckCurrentGlucose(); // qua bước nhập = false

            medicalObject.setChangeStatus(); // thay đổi trạng thái
          });
        }
      }
      Future.delayed(
          const Duration(seconds: 1),
          (() => showToast(
              "Lượng Glucose $value ${medicalObject.getCheckGlucozo(double.parse(value.toString())) == 0 ? "đạt mục tiêu" : "KHÔNG đạt mục tiêu"} ",
              duration: 3,
              gravity: Toast.bottom)));
    }
  }

  // callback when change infomation
  Future<void> _navigateAndDisplaySelection(
      BuildContext context, int index) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(
          builder: (context) => ProfileInfo(
                patienTemp: widget.patienTemp,
                index: index,
              )),
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
