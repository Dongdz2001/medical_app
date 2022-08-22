import 'dart:developer';
import 'package:async/async.dart';
import 'package:intl/intl.dart';
import 'controller_time.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

class Medical {
  // đo lượng đường trong  máu và nhập lại kết quả xuống bên dưới

  // delay solve
  String delaySolution1DayAt22h =
      "Bạn phải đợi đến 22h ( 15-08-2022 ) để đo đường máu mao mạch";
  void setDelaySolution1DayAt22h() {
    this.delaySolution1DayAt22h =
        "Bạn phải đợi đến 22h ( ${this.timeNextDay} ) để đo đường máu mao mạch";
    this.content_display =
        "Bạn phải đợi đến 22h ( ${this.timeNextDay} ) để đo đường máu mao mạch";
  }

  // nội dung chung cho cả 2 phương án đầu tiên
  String glucose_infusion_6H12H22H = """ 
-	 Truyền glucose 10% 500ml pha truyền 10UI Actrapid (1 chai, tốc độ 100ml/h) 
"""; //  6h – 12h – 22h
  get getGlucoseinfusion_6H12H22H => this.glucose_infusion_6H12H22H;
  set setGlucoseinfusion_6H12H22H(String value) =>
      this.glucose_infusion_6H12H22H = value;
  void setInitialGlucoseinfusion_6H12H22H() =>
      this.glucose_infusion_6H12H22H = """ 
-	 Truyền glucose 10% 500ml pha truyền 10UI Actrapid (1 chai, tốc độ 100ml/h)  
"""; //  6h – 12h – 22h

// nội dung phương án cho tiêm Insulin
  String yInsu22H = """ 
- Tiêm dưới da insulin tác dụng chậm :
    + Tiêm dưới da: 0.2 UI
    + Loại Insulin: Lantus
""";
  get getYInsu22H => this.yInsu22H;
  void setYInsu22H(double value1) => this.yInsu22H = """ 
- Tiêm dưới da insulin tác dụng chậm :
    + Tiêm dưới da: ${num.parse((this._lastStateBool ? (value1 * 0.2 + 2) : (value1 * 0.2)).toStringAsFixed(0))} UI
    + Loại Insulin: Lantus
""";

// nội dung phương án bổ sung khi không đạt mục tiêu
  String sloveFailedContext = "-  Tiêm dưới da Actrapid 2UI";
  get getSloveFailedContext => this.sloveFailedContext;
  void _setSloveFailedContext(int value) =>
      this.sloveFailedContext = "-  Tiêm dưới da Actrapid ${value} UI";

// nội dung phương án cho không tiêm Insulin
  String nInsulinAllTime = "- Tạm ngừng các thuốc hạ đường máu ";

// nội dung phương án cho không đạt mục tiêu ở phương án sử dụng trên
  String upLatium = "-  Tăng liều lên 2UI";

  // tên phác đồ
  String namePD = "Phác đồ hiện tại: \n NUÔI DƯỠNG ĐƯỜNG TĨNH MẠCH ";
  get getNamePD => this.namePD;
  // set setNamePD(String namePD) => this.namePD = namePD;

  // Thời gian bắt đầu phác đồ
  String timeStart = "00:00";
  get getTimeStart => this.timeStart;
  set setTimeStart(String timeStart) => this.timeStart = timeStart;

  // nội dung hiển thị
  String content_display = "Bạn có đang tiêm Insulin không :  ";
  get getContentdisplay => this.content_display;
  set setContentdisplay(String value) => this.content_display = value;

  // Kiểm tra trạng thái ban đầu
  bool _initialStateBool = false;
  get getInitialStateBool => this._initialStateBool;
  set setInitialStateBool(bool initialStateBool) =>
      this._initialStateBool = initialStateBool;
  // Kiểm tra trạng thai phương án cuối
  bool _lastStateBool = false;
  get getLastStateBool => this._lastStateBool;
  set setLastStateBool(bool value) => this._lastStateBool = value;

  // check restart app
  bool flagRestart = true;

  // Kiểm tra nồng độ Glucozo và in ra kết quả nếu failed
  void set_Content_State_Check_Gluco_Failed(double gluco) {
    if ((8.3 < gluco) && (gluco <= 11.1)) {
      _setSloveFailedContext(2);
    } else if (gluco > 11.1) {
      _setSloveFailedContext(4);
    } else {
      setYInsu22H(0.2);
      print("Có lỗi xảy ra, không xác định");
    }
  }

  // danh sách trạng thái tiêm đạt hay không (8 lần / ngày)
  List<double> _listResultInjection = [
    -1.0,
    -1.0,
    -1.0,
    -1.0,
    -1.0,
    -1.0,
    -1.0,
    -1.0
  ];

  get getListResultInjection => this._listResultInjection;
  // lấy ra list double data có giá trị
  List<double> _getListResultInjectValidValue() {
    List<double> listTemp = [];
    for (var i = 0; i < this._listResultInjection.length; i++) {
      if (this._listResultInjection[i] != -1) {
        listTemp.add(this._listResultInjection[i]);
      } else {
        break;
      }
    }
    return listTemp;
  }

  set setListResultInjection(List<double> listTemp) =>
      this._listResultInjection = listTemp;

  // danh sách thời gian đo đường máu mao mạch
  List<String> _listTimeResultInjection = [
    "none",
    "none",
    "none",
    "none",
    "none",
    "none",
    "none",
    "none"
  ];
  get getListTimeResultInjection => this._listTimeResultInjection;
  set setListTimeResultInjection(List<String> list) =>
      this._listTimeResultInjection = list;
  double getItemListResultInjection(int i) => this._listResultInjection[i];
  void addItemListResultInjectionItem(String value) {
    for (var i = 0; i < 8; i++) {
      if (_listResultInjection[i] + 1.0 == 0) {
        _listResultInjection[i] = double.parse(value);
        String s = DateTime.now().toString().substring(0, 16);
        List<String> listDH = s.split(' ');
        List<String> listDDMMYY = listDH[0].split('-');
        String result =
            "${listDH[1]}   ${listDDMMYY[2]}/${listDDMMYY[1]}/${listDDMMYY[0]}";
        _listTimeResultInjection[i] = result;
        break;
      }
    }
  }

  // lấy ra list String Time data có giá trị
  List<String> _getListResultInjectTimeValidValue() {
    List<String> listTemp = [];
    for (var i = 0; i < this._listTimeResultInjection.length; i++) {
      if (this._listTimeResultInjection[i] != "none") {
        listTemp.add(this._listTimeResultInjection[i]);
      } else {
        break;
      }
    }
    return listTemp;
  }

  // loại bỏ lần tiêm cuối trong danh sách
  void RemoveLastItemInjection() {
    for (var i = 7; i >= 0; i--) {
      if (_listResultInjection[i] != -1) {
        _listResultInjection[i] = -1;
        _listTimeResultInjection[i] = "none";
        break;
      }
    }
  }

  // kiểm tra hàm lượng glucozo có đạt mục tiêu hay không
  int getCheckGlucozo(double glu) {
    if (glu >= 3.9 && glu <= 8.3) {
      return 0;
    } else if (glu <= 11.1 && glu > 8.3) {
      return 1;
    } else if (glu > 11.1) {
      return 2;
    }
    return -1;
  }

  // kiểm tra lượng glucose hiện tại có đạt mục tiêu hay không ?
  bool getCheckGlucozoIndex(int i) => (this._listResultInjection[i] >= 3.9 &&
          this._listResultInjection[i] <= 8.3)
      ? true
      : false;
  // lấy ra kết quả cuối cùng
  double getLastFaildedResultValue() {
    for (int i = 7; i >= 0; i--) {
      if (this._listResultInjection[i] != -1)
        return this._listResultInjection[i];
    }
    return -1;
  }

  // lấy ra thời gian tiêm tại vị trí i
  String getTimeInjectItemList(int i) => _listTimeResultInjection[i];
  // l
  bool getItemCheckFlag(int i) =>
      getCheckGlucozo(getItemListResultInjection(i)) == 0 ? true : false;
  int getCountInject() {
    for (var i = 0; i < 8; i++) {
      if (this._listResultInjection[i] == -1) return i;
    }
    return 8;
  }

  // Reset value default;
  void resetInjectionValueDefault() {
    for (var i = 0; i < 8; i++) {
      this._listResultInjection[i] = -1;
      this._listTimeResultInjection[i] = "none";
    }
  }

  // reset all value
  void resetAllvalueIinitialStatedefaut() {
    resetInjectionValueDefault();
    this.listHistoryInjection = [];
    this.listHistoryTimeInjection = [];
    this.listOldSolveHistory = [];
    this.timeStart = DateTime.now().toString().substring(0, 16);
    this.setYInsu22H(0.2);
    this.timeNextCurrentValid();
    print("time == ${this.timeNext}");

    //  dừng phác đô lại
    this.checkBreak = false;
    // blockState ve trang thai ban dau
    blockStateIitial = false;
    // Reset time hiện tại
    String timeNextDay = DateFormat('dd-MM-yyyy').format(DateTime.now());
    // ẩn hiện thanh nhập cân nặng
    bool isVisibleWeight = false;
    // phương án đề xuất đã hiện hay chưa
    this.checkDoneTask = false;
    // lựa chọn phương án ban đầu
    this._initialStateBool = false;
    // chuyển phương án cuối
    this._lastStateBool = false;
    // ẩn hiện chỗ nhập glucose
    this.isVisibleGlucose = false;
    // Lựa chọn ban đầu
    this.isVisibleYesNoo = true;
    // ẩn hiện nút "chuyển tiếp"
    this.isVisibleButtonNext = false;
    // kiểm tra xem đẫ qua bước nhập glucose hiện tại hay chưa
    this.checkCurrentGlucose = false;
    // timeNext defalut
    this.content_display = "Bạn có đang tiêm Insulin không :  ";
  }

  // kiểm tra xem có đạt mục tiêu số lần đạt không
  int getCheckPassInjection() {
    int count = 0;
    for (var i = 0; i < getCountInject(); i++) {
      !getItemCheckFlag(i) ? count++ : null;
      if (count >= 5) {
        return 0; // không đạt mục tiêu
      }
    }
    if (getCountInject() - count >= 4) {
      return 1; // đạt mục tiêu
    }
    return -1; // chưa xác định
  }

  bool blockStateIitial = false;

  // Thiết lập trạng thái state  thay đổi
  void setChangeStatus() {
    if (!this.checkBreak) {
      if (!this.checkCurrentGlucose) {
        this.content_display = "";
        if (_initialStateBool || blockStateIitial) {
          this.content_display = "${nInsulinAllTime} \n";
          blockStateIitial = true;
        }
        if (getCheckOpenCloseTimeStatus("6:00", "6:30")) {
          if (this.checkDoneTask) {
            this.content_display =
                "Bạn phải đợi đến 12h để đo đường máu mao mạch";
          } else {
            this.content_display += " ${glucose_infusion_6H12H22H} ";
            if (getCheckGlucozo(this.getLastFaildedResultValue()) == 1) {
              this._setSloveFailedContext(2);
              this.content_display += this.sloveFailedContext;
            } else if (getCheckGlucozo(this.getLastFaildedResultValue()) == 2) {
              this._setSloveFailedContext(4);
              this.content_display += this.sloveFailedContext;
            }
            this._addOldSoloveHistory(this.content_display);
          }
        } else if (getCheckOpenCloseTimeStatus("6:31", "11:59")) {
          this.content_display =
              "Bạn phải đợi đến 12h  để đo đường máu mao mạch";
        } else if (getCheckOpenCloseTimeStatus("12:00", "12:30")) {
          if (this.checkDoneTask) {
            this.content_display =
                "Bạn phải đợi đến 18h để đo đường máu mao mạch";
          } else {
            this.content_display += "${glucose_infusion_6H12H22H}";
            if (getCheckGlucozo(this.getLastFaildedResultValue()) == 1) {
              this._setSloveFailedContext(2);
              this.content_display += this.sloveFailedContext;
            } else if (getCheckGlucozo(this.getLastFaildedResultValue()) == 2) {
              this._setSloveFailedContext(4);
              this.content_display += this.sloveFailedContext;
            }
            this._addOldSoloveHistory(this.content_display);
          }
        } else if (getCheckOpenCloseTimeStatus("12:31", "17:59")) {
          this.content_display =
              "Bạn phải đợi đến 18h để đo đường máu mao mạch";
        } else if (getCheckOpenCloseTimeStatus("18:00", "18:30")) {
          if (this.checkDoneTask) {
            this.content_display =
                "Bạn phải đợi đến 22h để đo đường máu mao mạch";
          } else {
            if (getCheckGlucozo(this.getLastFaildedResultValue()) == 1) {
              this._setSloveFailedContext(2);
              this.content_display += this.sloveFailedContext;
            } else if (getCheckGlucozo(this.getLastFaildedResultValue()) == 2) {
              this._setSloveFailedContext(4);
              this.content_display += this.sloveFailedContext;
            } else {
              this.content_display =
                  "Bạn phải đợi đến 22h để đo đường máu mao mạch";
            }
            this._addOldSoloveHistory(this.content_display);
          }
        } else if (getCheckOpenCloseTimeStatus("18:31", "21:59")) {
          this.content_display =
              "Bạn phải đợi đến 22h để đo đường máu mao mạch";
        } else if (getCheckOpenCloseTimeStatus("22:00", "22:30")) {
          if (this.checkDoneTask) {
            this.content_display =
                "Bạn phải đợi đến 6h sáng để đo đường máu mao mạch";
            this.timeNextDay = DateFormat('dd-MM-yyyy')
                .format(DateTime.now()); // update time day
          } else {
            if (this.isVisibleWeight) {
              this.content_display = "Nhập cân nặng hiện tại (Kg)";
            } else {
              if (!_initialStateBool) {
                this.content_display +=
                    " ${glucose_infusion_6H12H22H} ${yInsu22H}";
              } else {
                this.content_display += " ${glucose_infusion_6H12H22H}";
              }
              if (getCheckGlucozo(this.getLastFaildedResultValue()) == 1) {
                this._setSloveFailedContext(2);
                this.content_display += this.sloveFailedContext;
              } else if (getCheckGlucozo(this.getLastFaildedResultValue()) ==
                  2) {
                this._setSloveFailedContext(4);
                this.content_display += this.sloveFailedContext;
              }
              this._addOldSoloveHistory(this.content_display);
            }
          }
        } else {
          this.content_display =
              "Bạn phải đợi đến 6h sáng để đo đường máu mao mạch ";
        }
      } else {
        this.content_display = "Theo dõi đường máu mao mạch";
      }
    } else {
      this.content_display =
          "Phác đồ này không khả dụng nữa, hãy sử dụng một phác đô khác hiệu quả hơn";
    }
  }

  AsyncMemoizer<String> memCache = AsyncMemoizer();
  // Read data from RealTime Database
  Future<String> readDataRealTimeDB(String s) async {
    return memCache.runOnce(() async {
      final refer = FirebaseDatabase.instance.ref();
      // await refer.child(s).onValue.listen((event) {}
      final snapshot = await refer.child(s).get();
      if (snapshot.exists) {
        var value = Map<String, dynamic>.from(snapshot.value as Map);

        // get value from firebase
        this.checkBreak = value["checkBreak"];
        this.blockStateIitial = value["blockStateIitial"];
        this.timeNextDay = value["timeNextDay"];
        this.isVisibleWeight = value["isVisibleWeight"];
        this.timeNext = value["timeNext"];
        this.isVisibleButtonNext = value["isVisibleButtonNext"];
        this.isVisibleGlucose = value["isVisibleGlucose"];
        this.isVisibleYesNoo = value["isVisibleYesNoo"];
        this.checkCurrentGlucose = value["checkCurrentGlucose"];
        this.checkDoneTask = value["checkDoneTask"];
        this.setInitialStateBool = value["initialStateBool"];
        this.setLastStateBool = value["lastStateBool"];
        this.setListResultInjection =
            (value["listResultInjection"] as List<dynamic>)
                .map((e) => (e as int).toDouble())
                .toList();
        this.setListTimeResultInjection =
            (value["listTimeResultInjection"] as List<dynamic>)
                .map((e) => e.toString())
                .toList();
        this.setTimeStart = value["timeStart"].toString();
        this.sloveFailedContext = value["sloveFailedContext"];
        this.yInsu22H = value["yInsu22H"];

        this.flagRestart = value["flagRestart"] ?? false;
        if (value["listHistoryInjection"] != null) {
          this.listHistoryInjection =
              (value["listHistoryInjection"] as List<dynamic>)
                  .map((e) => (e as int).toDouble())
                  .toList();
          this.listHistoryTimeInjection =
              (value["listHistoryTimeInjection"] as List<dynamic>)
                  .map((e) => e.toString())
                  .toList();
        }
        if (value["listOldSolveHistory"] != null) {
          this.listOldSolveHistory =
              (value["listOldSolveHistory"] as List<dynamic>)
                  .map((e) => e.toString())
                  .toList();
        }

        // restart status
        this.flagRestart
            ? this.content_display = "Bạn có đang tiêm Insulin không :  "
            : this.content_display = value["content_display"];
        // default timeNext
        this.timeNextCurrentValid();
      }
      return "done";
    });
  }

  // Remove data
  Future<void> removeDataBase(String s) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(s);
    await ref.remove();
  }

  //check state display Object
  bool isVisibleGlucose = false; // hiển thị thanh nhập kết quả Glucose
  bool isVisibleYesNoo = true; //  hiển thị lựa chọn Yes/No
  bool isVisibleButtonNext = false; // hiển thị nút Next

  // kiểm tra hiện tại đã tới hay qua bước nhập hay chưa
  bool checkCurrentGlucose = false;

  // kiểm tra phương án đã hiển thị
  bool checkDoneTask = false;
  void setChangeCheckDoneTask() => this.checkDoneTask = !this.checkDoneTask;

  // change display checkCurrentGlucose
  void setChangeCheckCurrentGlucose() =>
      this.checkCurrentGlucose = !this.checkCurrentGlucose;

  // change display button next
  void setChangeVisibleButtonNext() =>
      this.isVisibleButtonNext = !this.isVisibleButtonNext;
  // void display mesuaring glucose
  void setChangeVisibleGlucose() =>
      this.isVisibleGlucose = !this.isVisibleGlucose;

  // kiểm tra thời gian đo hợp lệ
  bool checkValidMeasuringTimeFocus() {
    if (getCheckOpenCloseTimeStatus('6:00', '6:30') ||
        getCheckOpenCloseTimeStatus('12:00', '12:30') ||
        getCheckOpenCloseTimeStatus('18:00', '18:30') ||
        getCheckOpenCloseTimeStatus('22:00', '22:30')) {
      return true;
    }
    return false;
  }

  // Time next check
  String timeNext = '6:00_6:30';

  //in ra khoảng thời gian hợp lệ hiện tại
  void timeNextCurrentValid() {
    if (getCheckOpenCloseTimeStatus('6:31', '12:30')) {
      this.timeNext = '12:00_12:30';
    } else if (getCheckOpenCloseTimeStatus('12:31', '18:30')) {
      this.timeNext = '18:00_18:30';
    } else if (getCheckOpenCloseTimeStatus('18:31', '22:30')) {
      this.timeNext = '22:00_22:30';
    } else {
      this.timeNext = '6:00_6:30';
    }
  }

  // get timeCurrent
  String getTimeNextCurrentValid() {
    if (getCheckOpenCloseTimeStatus('6:31', '12:30')) {
      return '12:00_12:30';
    } else if (getCheckOpenCloseTimeStatus('12:31', '18:30')) {
      return '18:00_18:30';
    } else if (getCheckOpenCloseTimeStatus('18:31', '22:30')) {
      return '22:00_22:30';
    } else {
      return '6:00_6:30';
    }
  }

  // in ra thời gian theo dõi hợp lệ tiếp theo
  void timeNextValid() {
    if (getCheckOpenCloseTimeStatus('6:00', '6:30')) {
      this.timeNext = '12:00_12:30';
    } else if (getCheckOpenCloseTimeStatus('12:00', '12:30')) {
      this.timeNext = '18:00_18:30';
    } else if (getCheckOpenCloseTimeStatus('18:00', '18:30')) {
      this.timeNext = '22:00_22:30';
    } else {
      this.timeNext = '6:00_6:30';
    }
  }

  // get TimeNext
  String getTimeNextValid() {
    if (getCheckOpenCloseTimeStatus('6:00', '6:30')) {
      return '12:00_12:30';
    } else if (getCheckOpenCloseTimeStatus('12:00', '12:30')) {
      return '18:00_18:30';
    } else if (getCheckOpenCloseTimeStatus('18:00', '18:30')) {
      return '22:00_22:30';
    } else {
      return '6:00_6:30';
    }
  }

  // check TimeNext in a day
  bool checkTimeNext() {
    print("timeNext ${this.timeNext}");
    List<String> listTimeTemp = this.timeNext.split('_');
    if (getCheckOpenCloseTimeStatus(listTimeTemp[0], listTimeTemp[1]))
      return true;
    return false;
  }

  // Hiện đo cân nặng
  bool isVisibleWeight = false;
  void setChangeVisibleWeight() => this.isVisibleWeight = !this.isVisibleWeight;

  // Ngày tiếp theo (mặc định ngày hiện tại)
  String timeNextDay =
      DateFormat('dd-MM-yyyy').format(DateTime.now()); //14-08-2022

  // lấy ra ngày hiện tại
  String gettimeCurentDay() =>
      DateFormat('dd-MM-yyyy').format(DateTime.now()); // 14-08-2022
  void updateTimeNextDay() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    String formatted_tomorrow = formatter.format(tomorrow);
    timeNextDay = formatted_tomorrow;
  } //  15-08-2022

  // kiểm tra xem timeNextDay < curentDay hay không
  bool checkSmallerTimeNextDay() {
    List<String> listTimeTemp = this.timeNextDay.split('-');
    DateTime now = DateTime.now();
    if (int.parse(listTimeTemp[2]) < now.year) {
      print("year= ${int.parse(listTimeTemp[2])}");
      return true;
    } else if (int.parse(listTimeTemp[1]) < now.month) {
      print("month= ${int.parse(listTimeTemp[1])}");
      return true;
    } else if (int.parse(listTimeTemp[0]) < now.day) {
      print("day= ${int.parse(listTimeTemp[0])}");
      return true;
    }
    print("all= ${listTimeTemp}");
    return false;
  }

  // check time hiện tại  có bằng  timeNextDay hay không;
  bool checkTimeNextDay() {
    print(timeNextDay);
    return this.gettimeCurentDay() == timeNextDay;
  }

  // List kết quả đo glucose
  List<double> listHistoryInjection = [];
  // List time mỗi lần đo
  List<String> listHistoryTimeInjection = [];
  // List trạng thái theo dõi phác đồ
  List<String> listOldSolveHistory = [];

  // add oldSolve
  void _addOldSoloveHistory(String value) {
    for (var i = 0; i < this.listHistoryInjection.length; i++) {
      if (this.listOldSolveHistory[i] == "none") {
        this.listOldSolveHistory[i] = value;
        break;
      }
    }
  }

  // get length listHistoryInjection
  int lengthListHistoryInjection() => this.listHistoryInjection.length;

  // gán nhãn khi chuyển phương án điều trị
  void addLabelDatatoListHistoryFailed() {
    if (this._lastStateBool) {
      listHistoryInjection.add(-3);
      listHistoryTimeInjection.add("Phương án tăng liều LANTUS 2UI");
    } else if (!this._initialStateBool) {
      // this._initialStateBool = false là trạng thái tiêm insulin
      listHistoryInjection.add(-2);
      listHistoryTimeInjection.add("Phương án tiêm Insulin ");
    } else {
      listHistoryInjection.add(-1);
      listHistoryTimeInjection.add("Phương án không tiêm Insulin");
    }
    this.listOldSolveHistory.add("");
  }

  // add itemList History
  void addItemListHistory(String value) {
    if (this.listHistoryInjection.length == 0) {
      this.addLabelDatatoListHistoryFailed();
    }
    this.listHistoryInjection.add(double.parse(value));
    String s = DateTime.now().toString().substring(0, 16);
    List<String> listDH = s.split(' ');
    List<String> listDDMMYY = listDH[0].split('-');
    String result =
        "${listDH[1]} - ${listDDMMYY[2]}/${listDDMMYY[1]}/${listDDMMYY[0]}";
    this.listHistoryTimeInjection.add(result);
    this.listOldSolveHistory.add("none");
  }

  // dừng phương án điều trị khi không khả dụng nữa
  bool checkBreak = false;

  // save data on Firebase
  Future<void> saveData(String s) async {
    final reference = FirebaseDatabase.instance.ref(s);
    await reference.set({
      "namePD": this.getNamePD,
      "initialStateBool": this.getInitialStateBool,
      "content_display": this.content_display,
      "lastStateBool": this.getLastStateBool,
      "listResultInjection": this.getListResultInjection,
      "listTimeResultInjection": this.getListTimeResultInjection,
      "listHistoryInjection": this.listHistoryInjection,
      "listHistoryTimeInjection": this.listHistoryTimeInjection,
      "isVisibleGlucose": this.isVisibleGlucose,
      "isVisibleYesNoo": this.isVisibleYesNoo,
      "timeStart": this.getTimeStart.toString(),
      "sloveFailedContext": this.getSloveFailedContext,
      "yInsu22H": this.getYInsu22H,
      "flagRestart": this.flagRestart,
      "isVisibleButtonNext": this.isVisibleButtonNext,
      "checkCurrentGlucose": this.checkCurrentGlucose,
      "checkDoneTask": this.checkDoneTask,
      "timeNext": this.timeNext,
      "isVisibleWeight": this.isVisibleWeight,
      "timeNextDay": this.timeNextDay,
      "listOldSolveHistory": this.listOldSolveHistory,
      "blockStateIitial": this.blockStateIitial,
      "checkBreak": this.checkBreak,
      //  "address": {"line1": "100 Mountain View"}
    });
  }
}
