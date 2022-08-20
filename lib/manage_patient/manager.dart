import 'package:async/async.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'patient.dart';

class Manager {
  static final Manager _singleton = Manager._internal();

  factory Manager({required String key}) {
    _singleton.keyLogin = key;
    return _singleton;
  }

  Manager._internal();

  List<String> listInfomation = [];
  List<bool> listSelected = [];

  // login account
  String? keyLogin = "none";

  // add patient to list Object Patien
  void addPatient(
      String iD, String name, String regimen, bool saveMedicalFlag) {
    Patien patien = Patien(name: name, veryfileID: iD, regimen: regimen);
    patien.saveDataPatient(this.keyLogin!, saveMedicalFlag);
  }

  // add list infomation
  void addListInformation(String iD, String namePatient) {
    this.listInfomation.add("${iD}_(${namePatient})");
    this.listSelected.add(false);
  }

  // print listInfo
  void printListInfo() {
    for (var i = 0; i < listInfomation.length; i++) {
      print(listInfomation[i]);
    }
  }

  // get Name pateint index
  String getNameInfoPatientIndex(int i) {
    List<String> listemp = this.listInfomation[i].split("_");
    return listemp[1].substring(1, listemp[1].length - 1);
  }

  // get iD pateint index
  String getIdPatientIndex(int i) {
    print("id= ${this.listInfomation[i].substring(0, 12)}");
    return this.listInfomation[i].substring(0, 12);
  }

  Future<void> upSeverListInfo() async {
    final reference = FirebaseDatabase.instance.ref('${keyLogin}');
    await reference.update({
      "listInfo": this.listInfomation,
      "listSelected": this.listSelected,
    });
  }

  Future<void> upSeverListSelected() async {
    final reference = FirebaseDatabase.instance.ref('${keyLogin}');
    await reference.update({
      "listSelected": this.listSelected,
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

  void setSelect(int i) => listSelected[i] = !listSelected[i];

  // thay đổi màu item ListTile đc chọn
  void setSelecteDefaut() {
    for (var i = 0; i < this.size(); i++) {
      if (listSelected[i] == true) {
        this.setSelect(i);
        break;
      }
    }
  }

  bool checkIDExistID(String value) {
    for (var i = 0; i < size(); i++) {
      if (value == this.getIdPatientIndex(i)) return true;
    }
    return false;
  }

  int size() => listInfomation.length;

  // read listInfomation from Database RealTimeDB
  // Future<String> readDataRealTimeDBManager() async {
  //   final refer = FirebaseDatabase.instance.ref();
  //   // await refer.child(s).onValue.listen((event) {}
  //   final snapshot = await refer.child(this.keyLogin!.toString()).get();
  //   if (snapshot.exists) {
  //     var value = Map<String, dynamic>.from(snapshot.value as Map);
  //     if (value["listInfo"] != null) {
  //       this.listInfomation = (value["listInfo"] as List<dynamic>)
  //           .map((e) => e.toString())
  //           .toList();
  //       this.listSelected = (value["listSelected"] as List<dynamic>)
  //           .map((e) => (e as bool))
  //           .toList();
  //     } else {
  //       print("listInfo was Null");
  //     }
  //   }
  //   return "done";
  // }

  AsyncMemoizer<String> memCache = AsyncMemoizer();
  Future<String> readDataRealTimeDBManager() async {
    return memCache.runOnce(() async {
      final refer = FirebaseDatabase.instance.ref();
      // await refer.child(s).onValue.listen((event) {}
      final snapshot = await refer.child(this.keyLogin!.toString()).get();
      if (snapshot.exists) {
        var value = Map<String, dynamic>.from(snapshot.value as Map);
        if (value["listInfo"] != null) {
          this.listInfomation = (value["listInfo"] as List<dynamic>)
              .map((e) => e.toString())
              .toList();
          this.listSelected = (value["listSelected"] as List<dynamic>)
              .map((e) => (e as bool))
              .toList();
        } else {
          print("listInfo was Null");
        }
      }
      return "done";
    });
  }
}
