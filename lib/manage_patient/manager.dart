import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Manager {
  static final Manager _singleton = Manager._internal();

  factory Manager({required String key}) {
    _singleton.keyLogin = key;
    return _singleton;
  }

  Manager._internal();

  // danh sách bệnh nhân trong homeGroup
  List<String> listInfomation = [];
  List<String> listInfomationGroup = [];
  // danh sách lịch sử bệnh nhân trong home
  List<String> listHistoryInfomation = [];
  List<String> listHistoryInfomationGroup = [];
  // trạng thái được chọn của dánh sách bệnh nhân
  List<bool> listSelected = [];
  List<bool> listSelectedGroup = [];
  // bệnh nhân cuối cùng được chọn
  int back_steps_select = -1;
  int back_steps_selectGroup = -1;
  // tên người đăng nhập
  String nameUser = "";
  // Tên tài khoản đăng nhập (email)
  String nameEmailUser = "";
  // tên group đăng nhập
  String nameGroupJoin = "";

  // login account
  String? keyLogin = "none";

  // login group
  String? keyCodeGroup = "******";

  // add patient to list Object Patien
  // void addPatient(
  //     String iD, String name, String regimen, bool saveMedicalFlag) {
  //   Patien patien = Patien(name: name, veryfileID: iD, regimen: regimen);
  //   patien.saveDataPatient(this.keyLogin!, saveMedicalFlag);
  // }

  // add list infomation
  void addListInformation(String iD, String namePatient) {
    this.listInfomation.add("${iD}_(${namePatient})");
    this.listSelected.add(false);
  }

  void addListInformationGroup(String iD, String namePatient) {
    this.listInfomationGroup.add("${iD}_(${namePatient})");
    this.listSelectedGroup.add(false);
  }

  // print listInfo
  void printListInfo() {
    for (var i = 0; i < listInfomation.length; i++) {
      print(listInfomation[i]);
    }
  }

  // get Name pateint index in listInfo
  String getNameInfoPatientIndex(int i) {
    List<String> listemp = this.listInfomation[i].split("_");
    return listemp[1].substring(1, listemp[1].length - 1);
  }

  String getNameInfoPatientIndexGroup(int i) {
    List<String> listemp = this.listInfomationGroup[i].split("_");
    return listemp[1].substring(1, listemp[1].length - 1);
  }

  // get name pateint index in listHistoryInfo
  String getNameHistoryInfoPateintIndex(int i) {
    List<String> listTemp = this.listHistoryInfomation[i].split("_");
    return listTemp[1].substring(1, listTemp[1].length - 1);
  }

  String getNameHistoryInfoPateintIndexGroup(int i) {
    List<String> listTemp = this.listHistoryInfomationGroup[i].split("_");
    return listTemp[1].substring(1, listTemp[1].length - 1);
  }

  // get ID pateint index
  String getIdPatientIndex(int i) {
    // print("id= ${this.listInfomation[i].substring(0, 10)}");
    return this.listInfomation[i].substring(0, 10);
  }

  String getIdPatientIndexGroup(int i) {
    // print('hehehe = ${listInfomationGroup[i].substring(0, 10).toString()}');
    return this.listInfomationGroup[i].substring(0, 10);
  }

  // get ID history Pateint index
  String getIdHistoryPateintIndex(int i) {
    return this.listHistoryInfomation[i].substring(0, 10);
  }

  String getIdHistoryPateintIndexGroup(int i) {
    return this.listHistoryInfomationGroup[i].substring(0, 10);
  }

  // update all list from RealTime
  Future<void> upSeverListInfo() async {
    final reference = FirebaseDatabase.instance.ref('${keyLogin}');
    await reference.update({
      "listInfo": this.listInfomation,
      "listSelected": this.listSelected,
      "listHistoryInfo": this.listHistoryInfomation,
      "back_steps_select": this.back_steps_select
    });
  }

  // update all list from FireStore
  Future<void> upServerListInfoFireStore() async {
    CollectionReference groupFireStore =
        await FirebaseFirestore.instance.collection(this.keyCodeGroup!);
    await groupFireStore.get().then((QuerySnapshot querySnapshot) {
      groupFireStore
          .doc('information_Pateint')
          .update({
            "listInfo": this.listInfomationGroup,
            "listSelected": this.listSelectedGroup,
            "listHistoryInfo": this.listHistoryInfomationGroup,
            "back_steps_select": this.back_steps_selectGroup
          })
          .then((value) => print("List Selection was updated"))
          .catchError(
              (error) => print("Failed to update List Selection: $error"));
    });
  }

  // Save name of User
  Future<void> saveNameUser(String s) async {
    final reference = FirebaseDatabase.instance.ref('${keyLogin}');
    await reference.update({"nameUser": s});
  }

  // Save name of Email User
  Future<void> saveNameEmailUser(String s) async {
    final reference = FirebaseDatabase.instance.ref('${keyLogin}');
    await reference.update({"nameEmailUser": s});
  }

  //Save password of Email User
  Future<void> savePassWordOfEmailUser(String email, String password) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("listpassword");
    await ref.update({
      "$email": password,
    });
  }

  // Read name of User
  Future<void> readNameUser() async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref('${this.keyLogin}/nameUser');
    DatabaseEvent event = await reference.once();
    this.nameUser = event.snapshot.value.toString();
  }

  // Read name of Email User
  Future<void> readNameEmailUser() async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref('${this.keyLogin}/nameEmailUser');
    DatabaseEvent event = await reference.once();
    this.nameEmailUser = event.snapshot.value.toString();
  }

  // update list Selected from realTimeDB
  Future<void> upSeverListSelected() async {
    final reference = FirebaseDatabase.instance.ref('${keyLogin}');
    await reference.update({
      "listSelected": this.listSelected,
    });
  }

  // update list Slected from FireStore
  Future<void> upSever_FireStore_ListSelected() async {
    // final reference = FirebaseDatabase.instance.ref('${keyLogin}');
    CollectionReference groupFireStore =
        await FirebaseFirestore.instance.collection(this.keyCodeGroup!);
    await groupFireStore.get().then((QuerySnapshot querySnapshot) {
      groupFireStore
          .doc('information_Pateint')
          .update({
            "listSelected": this.listSelectedGroup,
          })
          .then((value) => print("List Selection was updated"))
          .catchError(
              (error) => print("Failed to update List Selection: $error"));
    });
  }

  // update danh sách bệnh nhân trên RealTime
  Future<void> upDateNameIndexListInfo(int index, String name) async {
    this.listInfomation[index] =
        '${this.listInfomation[index].substring(0, 10)}_(${name})';
    final reference = FirebaseDatabase.instance.ref('${keyLogin}');
    await reference.update({
      "listInfo": this.listInfomation,
    });
  }

  // update danh sách bệnh nhân trên FireStore
  Future<void> upDateNameIndexListInfoFireStore(int index, String name) async {
    this.listInfomationGroup[index] =
        '${this.listInfomationGroup[index].substring(0, 10)}_(${name})';
    CollectionReference groupFireStore =
        await FirebaseFirestore.instance.collection(this.keyCodeGroup!);
    await groupFireStore.get().then((QuerySnapshot querySnapshot) {
      groupFireStore
          .doc('information_Pateint')
          .update({
            "listInfo": this.listInfomationGroup,
          })
          .then((value) => print("List Selection was updated"))
          .catchError(
              (error) => print("Failed to update List Selection: $error"));
    });
  }

  bool isEmpty(int i) => listInfomation[i] == Null;

  // Patien getPainent(int i) => !isEmpty(i) ? listInfomation[i] : listInfomation[0];

  // void removePainet(int ID) {
  //   for (var i = 0; i < listInfomation.length; i++) {
  //     if (listInfomation[i].getID == ID) listInfomation.removeAt(i);
  //   }
  // }

  void setListInforDefault() {
    this.listInfomation = [];
    this.listSelected = [];
  }

  void setListInforDefaultGroup() {
    this.listInfomationGroup = [];
    this.listSelectedGroup = [];
  }

  void setSelect(int i) => listSelected[i] = !listSelected[i];
  void setSelectGroup(int i) => listSelectedGroup[i] = !listSelectedGroup[i];

  // thay đổi màu item ListTile đc chọn
  void setSelecteDefaut() {
    for (var i = 0; i < this.size(); i++) {
      if (listSelected[i] == true) {
        this.setSelect(i);
        break;
      }
    }
  }

  void setSelecteDefautGroup() {
    for (var i = 0; i < this.sizeGroup(); i++) {
      if (listSelectedGroup[i] == true) {
        this.setSelectGroup(i);
        break;
      }
    }
  }

  // setDefault all value in list Group
  void setDefaultAllValueGroup() {
    this.listInfomationGroup = [];
    this.listSelectedGroup = [];
    this.listHistoryInfomationGroup = [];
    this.back_steps_select = -1;
  }

  bool checkIDExistID(String value) {
    for (var i = 0; i < size(); i++) {
      if (value == this.getIdPatientIndex(i)) return true;
    }
    return false;
  }

  bool checkIDExistIDGroup(String value) {
    for (var i = 0; i < sizeGroup(); i++) {
      if (value == this.getIdPatientIndexGroup(i)) return true;
    }
    return false;
  }

  int size() => listInfomation.length;
  int sizeGroup() => listInfomationGroup.length;

  // đọc dữ liệu người dùng từ FireStore
  Future<String> readDataFireStoreDBManager() async {
    bool checkCreateNewDoc = true;
    await FirebaseFirestore.instance
        .collection(this.keyCodeGroup!)
        .doc('information_Pateint')
        .get()
        .then((DocumentSnapshot value) async {
      if (value.exists) {
        checkCreateNewDoc = false;
        bool checkDataExits = true;
        try {
          value["back_steps_select"];
        } catch (e) {
          checkDataExits = false;
        }

        if (checkDataExits) {
          this.back_steps_selectGroup = value["back_steps_select"] ?? -1;
          List<dynamic> listTemp = value["listInfo"] ?? [];
          this.listInfomationGroup =
              (listTemp).map((e) => e.toString()).toList();

          listTemp = value["listSelected"] ?? [];
          this.listSelectedGroup =
              (listTemp).map((e) => e.toString() == 'true').toList();

          listTemp = value["listHistoryInfo"] ?? [];
          this.listHistoryInfomationGroup =
              (listTemp).map((e) => e.toString()).toList();
        }
      }
    });

    if (checkCreateNewDoc) {
      CollectionReference groups =
          await FirebaseFirestore.instance.collection(this.keyCodeGroup!);
      await groups
          .doc("information_Pateint")
          .set({
            'list_info_pateint': [],
          })
          .then((value) => print("This new List Member Of Group was added"))
          .catchError((onError) =>
              print("Failed to add new List Mem Of Group: $onError"));
    }

    return "done";
  }

  // đọc dữ liệu từ realtime DB cho người dùng Login
  Future<String> readDataRealTimeDBManager() async {
    final refer = FirebaseDatabase.instance.ref();
    final snapshot = await refer.child(this.keyLogin!.toString()).get();
    if (snapshot.exists) {
      var value = Map<String, dynamic>.from(snapshot.value as Map);
      if (value["nameUser"] != null) {
        this.nameUser = value["nameUser"];
      }
      if (value["back_steps_select"] != null) {
        this.back_steps_select = value["back_steps_select"];
      }
      if (value["listInfo"] != null) {
        this.listInfomation = (value["listInfo"] as List<dynamic>)
            .map((e) => e.toString())
            .toList();
        this.listSelected = (value["listSelected"] as List<dynamic>)
            .map((e) => (e as bool))
            .toList();
      } else {
        print("listInfo was Null");
        this.listInfomation = [];
      }
      if (value["listHistoryInfo"] != null) {
        this.listHistoryInfomation = (value["listHistoryInfo"] as List<dynamic>)
            .map((e) => e.toString())
            .toList();
      } else {
        print("listHistoryInfo was Null");
        this.listHistoryInfomation = [];
      }
    } else {
      this.listInfomation = [];
      this.listSelected = [];
      this.back_steps_select = -1;
    }
    return "done";
    // });
  }
}
