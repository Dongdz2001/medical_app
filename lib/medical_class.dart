import 'package:medical_app/controller_time.dart';

class Medical {
  // đo lượng đường trong  máu và nhập lại kết quả xuống bên dưới
  String symetricGlucozoContent = "Đo nồng độ glucozo và nhập lại kết quả";

  // nội dung chung cho cả 2 phương án đầu tiên
  String glucose_infusion_6H12H22H = """ 
-	 Truyền glucose 10% 500ml \n pha truyền 10UI Actrapid (1 chai, 100ml/h)  
"""; //  6h – 12h – 22h
  get getGlucoseinfusion_6H12H22H => this.glucose_infusion_6H12H22H;
  set setGlucoseinfusion_6H12H22H(String value) =>
      this.glucose_infusion_6H12H22H = value;
  void setInitialGlucoseinfusion_6H12H22H() =>
      this.glucose_infusion_6H12H22H = """ 
-	 Truyền glucose 10% 500ml \n pha truyền 10UI Actrapid (1 chai, 100ml/h)  
"""; //  6h – 12h – 22h

// nội dung phương án cho tiêm Insulin
  String yInsu22H = """ 
- Tiêm dưới da insulin tác dụng chậm :
    + Liều khởi đầu: 0.2 UI/kg/ngày 
    + Loại Insulin: Lantus
""";

  get getYInsu22H => this.yInsu22H;
  void setYInsu22H(double value) => this.yInsu22H = """ 
- Tiêm dưới da insulin tác dụng chậm :
    + Liều khởi đầu: ${value} UI/kg/ngày 
    + Loại Insulin: Lantus
""";

// nội dung phương án bổ sung khi không đạt mục tiêu
  String sloveFailedContext = "Tiêm dưới da Actrapid 2UI\n";
  get getSloveFailedContext => this.sloveFailedContext;
  void _setSloveFailedContext(int value) =>
      this.sloveFailedContext = "Tiêm dưới da Actrapid ${value}UI\n";

// nội dung phương án cho không tiêm Insulin
  String nInsulinAllTime = " Tạm ngừng các thuốc hạ đường máu ";

// nội dung phương án cho không đạt mục tiêu ở phương án sử dụng trên
  String upLatium = "Tăng liều lên 2UI";

  // tên phác đồ
  String namePD = "Phác đồ hiện tại: \n NUÔI DƯỠNG ĐƯỜNG TĨNH MẠCH ";
  get getNamePD => this.namePD;
  // set setNamePD(String namePD) => this.namePD = namePD;

  // Thời gian bắt đầu phác đồ
  String timeStart = "00:00";
  get getTimeStart => this.timeStart;
  set setTimeStart(String timeStart) => this.timeStart = timeStart;

  // nội dung hiển thị
  String _content_display = "Bạn có đang tiêm Insulin không :  ";
  get getContentdisplay => this._content_display;
  set setContentdisplay(String value) => this._content_display = value;

  // Kiểm tra trạng thái ban đầu
  bool _initialStateBool = false;
  get getInitialStateBool => this._initialStateBool;
  set setInitialStateBool(bool initialStateBool) =>
      this._initialStateBool = initialStateBool;
  // Kiểm tra trạng thai phương án cuối
  bool _lastStateBool = false;
  get getLastStateBool => this._lastStateBool;
  set setLastStateBool(bool value) => this._lastStateBool = value;

  // số lần sử dụng 1 phương án
  int countUsedSolve = 0;
  get getCountUsedSolve => this.countUsedSolve;
  void upCountUsedSolve() => this.countUsedSolve++;
  void downCountUsedSolve() => this.countUsedSolve--;

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
  List<double> _listResultInjection = [-1, -1, -1, -1, -1, -1, -1, -1];
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
  double getItemListResultInjection(int i) => this._listResultInjection[i];
  void addItemListResultInjectionItem(double value) {
    for (var i = 0; i < 8; i++) {
      if (_listResultInjection[i] == -1) {
        _listResultInjection[i] = value;
        _listTimeResultInjection[i] =
            DateTime.now().toString().substring(0, 16);
        break;
      }
    }
  }

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
  bool getCheckGlucozo(double glu) => (glu >= 3.9 && glu <= 8.3) ? true : false;
  bool getCheckGlucozoIndex(int i) => (this._listResultInjection[i] >= 3.9 &&
          this._listResultInjection[i] <= 8.3)
      ? true
      : false;
  double getLastFaildedResultValue() {
    for (int i = 7; i >= 0; i--) {
      if (!getCheckGlucozoIndex(i) && this._listResultInjection[i] != -1)
        return this._listResultInjection[i];
    }

    return -1;
  }

  // lấy ra thời gian tiêm
  String getTimeInjectItemList(int i) => _listTimeResultInjection[i];

  bool getItemCheckFlag(int i) =>
      getCheckGlucozo(getItemListResultInjection(i));
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
    this.timeStart = DateTime.now().toString().substring(0, 16);
    this.setYInsu22H(0.2);
    if (getCountUsedSolve == 1) {
      downCountUsedSolve();
    }
  }

  // kiểm tra xem có đạt mục tiêu số lần đạt không
  int getCheckPassInjection() {
    int count = 0;
    for (var i = 0; i < getCountInject(); i++) {
      !getItemCheckFlag(i) ? count++ : null;
      if (count >= 5) {
        return 0;
      }
    }
    if (getCountInject() - count >= 4) {
      return 1;
    }
    return -1;
  }

  // Thiết lập trạng thái state ban đầu
  void setStateInitial() {
    this._content_display = "";
    if (_initialStateBool) {
      this._content_display = "${nInsulinAllTime} \n";
    }
    if (getCheckOpenCloseTimeStatus("6:31", "12:30")) {
      this._content_display +=
          "Trong khoảng 12h-12h30p trưa: \n ${glucose_infusion_6H12H22H}";
      if (getCountUsedSolve == 1) {
        this._content_display += getSloveFailedContext;
      }
      this._content_display += symetricGlucozoContent;
    } else if (getCheckOpenCloseTimeStatus("12:31", "18:30")) {
      this._content_display +=
          "Trong khoảng 6h - 6h30p tối: \n ${symetricGlucozoContent}";
    } else if (getCheckOpenCloseTimeStatus("18:31", "22:31")) {
      if (!_initialStateBool) {
        this._content_display +=
            "Trong khoảng 22h-22h30p đêm: \n ${glucose_infusion_6H12H22H} ${yInsu22H}";
      } else {
        this._content_display +=
            "Trong khoảng 22h-22h30p đêm: \n ${glucose_infusion_6H12H22H}";
      }

      if (getCountUsedSolve == 1) {
        this._content_display += getSloveFailedContext;
      }
      this._content_display += symetricGlucozoContent;
    } else {
      this._content_display +=
          "Trong khoảng 6h-6h30p sáng: \n ${glucose_infusion_6H12H22H} ";
      if (getCountUsedSolve == 1) {
        this._content_display += getSloveFailedContext;
      }
      this._content_display += symetricGlucozoContent;
    }
  }
}

// class MedicalList {
//   List<Medical> items = [];

//   toJSONEncodable() {
//     return items.map((item) {
//       return item.toJSONEncodable();
//     }).toList();
//   }
// }
