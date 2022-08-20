import 'package:async/async.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:medical_app/detail_logic/medical_class.dart';

class Patien {
  String? name = 'None';
  String? keyLogin = "None";
  int? old = -1;
  String? gender = "unknow";
  String? address;
  String? regimen = "None";
  String? nameDisease = "None";
  String? veryfileID;
  String? phoneNum = '';
  String? birthday = '';

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
  Future<void> saveDataPatient(String keyLogin, bool flagSaveMeical) async {
    if (this.keyLogin == "None") {
      this.keyLogin = keyLogin;
    }
    final reference =
        FirebaseDatabase.instance.ref('${keyLogin}/Users/${this.getID}');
    await reference.set({
      "name": this.name,
      "old": this.old,
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
  }

  // read Data from realTime
  // AsyncMemoizer<String> memCache = AsyncMemoizer();
  // Read data from RealTime Database
  Future<String> readDataRealTimeDB(String s) async {
    // return memCache.runOnce(() async {
    final refer = FirebaseDatabase.instance.ref();
    // await refer.child(s).onValue.listen((event) {}
    final snapshot = await refer.child(s).get();
    if (snapshot.exists) {
      var value = Map<String, dynamic>.from(snapshot.value as Map);

      // get value from firebase
      this.name = value["name"];
      this.old = value["old"];
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
    // });
  }

  // Contructor patien
  Patien(
      {required this.name,
      this.old,
      this.address,
      @required this.veryfileID,
      @required this.regimen = "Nuôi dưỡng đường tĩnh mạch"});
}
