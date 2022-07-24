import 'package:medical_app/controller_time.dart';

class Medical {
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
  String sloveFailedContext = "Tiêm dưới da 2UI";
  get getSloveFailedContext => this.sloveFailedContext;
  void setSloveFailedContext(int value) =>
      this.sloveFailedContext = "Tiêm dưới da ${value}UI";

// nội dung phương án cho không tiêm Insulin
  String nInsulinAllTime = " Tạm ngừng các thuốc hạ đường máu ";

// nội dung phương án cho không đạt mục tiêu ở phương án sử dụng trên
  String upLatium = "Tăng liều lên 2UI";

  // tên phác đồ
  String namePD = "Phác đồ hiện tại: \n NUÔI DƯỠNG ĐƯỜNG TĨNH MẠCH ";
  get getNamePD => this.namePD;
  // set setNamePD(String namePD) => this.namePD = namePD;

  // nội dung hiển thị
  String _content_display = "Bạn có đang tiêm Insulin không :  ";
  get getContentdisplay => this._content_display;
  set setContentdisplay(String value) => this._content_display = value;

  // thiết lập trạng thái ban đầu
  bool _initialStateBool = false;
  get getInitialStateBool => this._initialStateBool;
  set setInitialStateBool(bool initialStateBool) =>
      this._initialStateBool = initialStateBool;

  // số lần sử dụng 1 phương án
  int countUsedSolve = 0;
  get getCountUsedSolve => this.countUsedSolve;
  set setCountUsedSolve(int countUsedSolve) =>
      this.countUsedSolve = countUsedSolve;

  // Kiểm tra nồng độ Glucozo và in ra kết quả nếu failed
  void set_Content_State_Check_Gluco_Failed(double gluco) {
    if ((8.3 < gluco) && (gluco <= 11.1)) {
      setSloveFailedContext(2);
    } else if (gluco > 11.1) {
      setSloveFailedContext(4);
    } else {
      setYInsu22H(0.2);
      print("Có lỗi xảy ra, không xác định");
    }
  }

  // kiểm tra hàm lượng glucozo có đạt mục tiêu hay không
  bool getCheckGlucozo(double glu) => (glu >= 3.9 && glu <= 8.3) ? true : false;

  // danh sách trạng thái tiêm đạt hay không (8 lần / ngày)
  List<double> _listResultInjection = [-1, -1, -1, -1, -1, -1, -1, -1];
  double getItemListResultInjection(int i) => this._listResultInjection[i];
  void setItemListResultInjectionItem(int i, double value) =>
      this._listResultInjection[i] = value;
  bool getItemCheckFlag(int i) =>
      getCheckGlucozo(getItemListResultInjection(i));
  int getCountInject() {
    for (var i = 0; i < 8; i++) {
      if (this._listResultInjection[i] == -1) return i;
    }
    return 8;
  }

  // kiểm tra xem có đạt mục tiêu số lần đạt không
  bool getCheckPassInjection() {
    int count = 0;
    for (var i = 0; i < getCountInject(); i++) {
      !getItemCheckFlag(i) ? count++ : null;
      if (count == 5) {
        return false;
      }
    }
    return true;
  }

  // Thiết lập trạng thái state ban đầu
  void setStateInitial() {
    this._content_display = "";
    if (_initialStateBool) {
      this._content_display = "${nInsulinAllTime} \n";
    }
    if (getCheckOpenCloseTimeStatus("6:31", "12:30")) {
      this._content_display +=
          "Trong khoảng 12h-12h30p trưa: \n ${glucose_infusion_6H12H22H} \n";
      if (getCountUsedSolve == 1) {
        this._content_display += getSloveFailedContext;
      }
    } else if (getCheckOpenCloseTimeStatus("12:31", "22:31")) {
      this._content_display +=
          "Trong khoảng 22h-22h30p đêm: \n ${glucose_infusion_6H12H22H} ${yInsu22H}";
      if (getCountUsedSolve == 1) {
        this._content_display += getSloveFailedContext;
      }
    } else {
      this._content_display +=
          "Trong khoảng 6h-6h30p sáng: \n ${glucose_infusion_6H12H22H} \n";
      if (getCountUsedSolve == 1) {
        this._content_display += getSloveFailedContext;
      }
    }
  }
}
