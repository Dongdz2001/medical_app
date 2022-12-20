import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:medical_app/NDDTM_medical/medical_class.dart';

class Patien {
  // Tên bệnh nhân
  String? name = 'None';
  // mã realtime
  String? keyLogin = "None";
  // tuổi bệnh nhân
  int? old = -1;
  // giới tính bệnh nhân
  String? gender = "unknow";
  // địa chỉ bệnh nhân
  String? address;
  // phác đồ điều trị hiện tại
  String? regimen = "None";
  // tên bệnh được chuẩn đoán
  String? nameDisease = "None";
  // mã ID của bệnh nhân
  String? veryfileID;
  // số điện thoại
  String? phoneNum = '';
  // ngày tháng năm sinh
  String? birthday = '';
  // cân nặng hiện tại
  double? weight = -1;

  Object objRegimen = Medical();

  // get set for birthday
  get getBirthday => this.birthday;
  set setBirthday(String birthday) => this.birthday = birthday;

  // get set phone number
  get getPhoneNum => this.phoneNum;
  set setPhoneNum(String phoneNum) => this.phoneNum = phoneNum;

  // get set phác đồ đã chọn
  get getObjRegimen => this.objRegimen;
  set setObjRegimen(Object objRegimen) => this.objRegimen = objRegimen;

  //get set name of regimen
  get getRegimen => this.regimen;
  set setRegimen(regimen) => this.regimen = regimen;

  // Contructor getter and setter name
  get getName => this.name;
  set _setName(name) => this.name = name;

  // get and set old
  get getOld => this.old;
  set _setOld(old) => this.old = old;

  // get and set address
  get getAddress => this.address;
  set _setAddress(address) => this.address = address;

  // get and set ID
  get getID => this.veryfileID;
  set setID(String ID) => this.veryfileID = ID;

  void setRegimenObject() {
    if (this.regimen == 'Nuôi dưỡng đường tĩnh mạch') {
      this.objRegimen = Medical();
    } else if (this.regimen == 'Nuôi cấy tế bào gốc') {
    } else if (this.regimen == 'Điều trị đau vai gáy') {}
  }

  // save data patient
  Future<void> saveDataPatient(
      bool checkGroupOrPersonal, String keyLogin, bool flagSaveMeical,
      {String keyCodeGroup = ""}) async {
    if (this.keyLogin == "None") {
      this.keyLogin = keyLogin;
    }
    // checkGroupOrPersonal == true ? saveFireStore : saveRealTime
    if (!checkGroupOrPersonal) {
      final reference =
          FirebaseDatabase.instance.ref('${keyLogin}/Users/${this.getID}');
      await reference.set({
        "name": this.name,
        "old": this.old,
        "weight": this.weight,
        "gender": this.gender,
        "address": this.address,
        "regimen": this.regimen,
        "veryfileID": this.veryfileID,
        "nameDisease": this.nameDisease,
        "phoneNum": this.phoneNum,
        "birthday": this.birthday,
        "keyLogin": this.keyLogin
      });
      if (this.objRegimen is Medical && flagSaveMeical) {
        (this.objRegimen as Medical)
            .saveData('${keyLogin}/Users/${this.getID}/Medical');
      }
    } else {
      String path = "Users.${this.getID}";
      CollectionReference groupFireStore =
          await FirebaseFirestore.instance.collection(keyCodeGroup);
      await groupFireStore.get().then((QuerySnapshot querySnapshot) {
        groupFireStore
            .doc('information_Pateint')
            .update({
              "$path.name": this.name,
              "$path.old": this.old,
              "$path.weight": this.weight,
              "$path.gender": this.gender,
              "$path.address": this.address,
              "$path.regimen": this.regimen,
              "$path.veryfileID": this.veryfileID,
              "$path.nameDisease": this.nameDisease,
              "$path.phoneNum": this.phoneNum,
              "$path.birthday": this.birthday,
            })
            .then((value) => print("List Selection was updated"))
            .catchError(
                (error) => print("Failed to update List Selection: $error"));
      });
      if (this.objRegimen is Medical && flagSaveMeical) {
        (this.objRegimen as Medical)
            .saveDataFireStore(keyCodeGroup, 'Users.${this.getID}.Medical');
      }
    }
  }

  // read Data from realTime
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
        this.name = value["name"];

        this.weight = value["weight"] is int
            ? double.parse("${value["weight"]}.0")
            : value["weight"];
        this.old = _caculateOld(value["birthday"]);
        this.gender = value["gender"];
        this.address = value["address"];
        this.regimen = value["regimen"];
        this.veryfileID = value["veryfileID"];
        this.nameDisease = value["nameDisease"];
        this.phoneNum = value["phoneNum"];
        this.birthday = value["birthday"];
        this.keyLogin = value["keyLogin"];
        if (value["Medical"] != null) {
          if (objRegimen is Medical) {
            (objRegimen as Medical).readDataRealTimeDB("${s}/Medical");
          }
        }
      }
      return "done";
    });
  }

  // Read data from FireStore Database
  AsyncMemoizer<String> memCacheFireStore = AsyncMemoizer();
  Future<String> readDataFireStoreDB(String keycode, String s) async {
    return memCacheFireStore.runOnce(() async {
      await FirebaseFirestore.instance
          .collection(keycode)
          .doc('information_Pateint')
          .get()
          .then((DocumentSnapshot value) {
        // print("s= $s");
        if (value.exists) {
          bool checkHasData = true;
          try {
            value["$s.name"];
          } catch (e) {
            checkHasData = false;
          }
          if (checkHasData) {
            this.name = value["$s.name"] ?? 'none none';
            this.weight = value["$s.weight"] is int
                ? double.parse("${value["$s.weight"]}.0")
                : value["$s.weight"] ?? -1;
            String oldTemp = value["$s.birthday"] ?? '01/01/2001';
            this.old = _caculateOld(oldTemp);
            this.gender = value["$s.gender"] ?? 'Nữ';
            this.address = value["$s.address"] ?? 'none';
            this.regimen = value["$s.regimen"] ?? 'none';
            this.veryfileID = value["$s.veryfileID"] ?? 'none';
            this.nameDisease = value["$s.nameDisease"] ?? 'none';
            this.phoneNum = value["$s.phoneNum"] ?? '12345678';
            this.birthday = value["$s.birthday"] ?? '01/01/2001';
            try {
              // print("check Medical ${value["$s.Medical"]}");
              if (objRegimen is Medical) {
                (objRegimen as Medical)
                    .readDataFireStoreDB(keycode, "$s.Medical");
              }
            } catch (e) {
              print("Medial was empty");
            }
          }
        }
      });
      return "done";
    });
  }

  // tính tuổi
  int _caculateOld(String dateStr) {
    // DateTime dateTime = DateTime.now().year;
    try {
      return DateTime.now().year -
          int.parse(dateStr.substring(dateStr.length - 4));
    } catch (e) {
      print("Casting date error");
    }
    return -1;
  }

  // Contructor patien
  Patien(
      {required this.name,
      @required this.veryfileID,
      this.weight,
      this.gender,
      this.birthday,
      @required this.regimen = "Nuôi dưỡng đường tĩnh mạch"});
}
