import 'package:flutter/cupertino.dart';
import 'package:medical_app/detail_logic/medical_class.dart';

class Patien {
  String? name = 'None';
  int? old = -1;
  String? gender = "unknow";
  String? address;
  String? regimen = "None";
  String? nameDisease = "None";
  int? veryfileID;
  String? phoneNum = '';
  String? birthday = '';
  bool selected = false;
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

  void setSelected() => this.selected = !this.selected;

  get getSelected => this.selected;
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
  set _setID(ID) => this.veryfileID = ID;

  void setRegimenObject() {
    if (this.regimen == 'Nuôi dưỡng đường tĩnh mạch') {
      this.objRegimen = Medical();
    } else if (this.regimen == 'Nuôi cấy tế bào gốc') {
    } else if (this.regimen == 'Điều trị đau vai gáy') {}
  }

  void saveDataPateint() {
    if (this.objRegimen is Medical) {
      (this.objRegimen as Medical).saveData('Medical/${this.getID}');
    }
  }

  // Contructor patien
  Patien(
      {required this.name,
      this.old,
      this.address,
      @required this.veryfileID,
      @required this.regimen});
}
