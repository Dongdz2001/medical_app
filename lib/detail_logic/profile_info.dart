import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_app/authentication/login/home_screen.dart';
import 'package:medical_app/detail_logic/sizeDevide.dart';
import 'package:medical_app/manage_patient/patient.dart';

class ProfileInfo extends StatefulWidget {
  final Object? patienTemp;
  const ProfileInfo({Key? key, required this.patienTemp}) : super(key: key);
  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  late Patien patienTemp;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  TextEditingController diseaseControler = TextEditingController();
  TextEditingController nameControler = TextEditingController();
  TextEditingController identityCardControler = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    patienTemp = widget.patienTemp! as Patien;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff091a31),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15, right: 20),
            child: TextButton(
              child: const Text('Lưu'),
              onPressed: () {
                print(
                    "information: ${diseaseControler.text} - ${nameControler.text} - ${identityCardControler.text} - ${genderController.text} - ${dateController.text} - ${phoneController.text}");
                patienTemp.name = nameControler.text;
                patienTemp.gender = genderController.text == ''
                    ? 'unknow'
                    : genderController.text;
                patienTemp.birthday = dateController.text;
                try {
                  patienTemp.veryfileID = identityCardControler.text.toString();
                } catch (e) {
                  print('casting error');
                }
                patienTemp.phoneNum = phoneController.text;
                patienTemp.nameDisease = diseaseControler.text;
                patienTemp.old = _caculateOld(dateController.text);
                patienTemp.saveDataPatient(patienTemp.keyLogin!, false);
                Navigator.pop(context, true);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // image profile
              Container(
                alignment: Alignment.topCenter,
                color: Color(0xff091a31),
                height: heightDevideMethod(0.2),
                width: widthDevide,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 115,
                      width: 115,
                      child: this._image == null
                          ? CircleAvatar(
                              radius: 48, // Image radius
                              backgroundImage: NetworkImage(
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqkKsJE9otzQr3RAnkLRCThzaxfoJ0_6W2sg&usqp=CAU'),
                            )
                          : ClipOval(
                              child: Image.file(
                                _image!,
                                width: 115,
                                height: 115,
                                fit: BoxFit.contain,
                              ),
                            ),
                    ),
                    Positioned(
                      right: 0,
                      child: InkWell(
                        onTap: () async => await _pickImageCamera(),
                        child: ClipOval(
                            child: Container(
                          padding: EdgeInsets.all(4),
                          color: Colors.red,
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        )),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: heightDevideMethod(0.02)),
              buildUserInfoDisplay(diseaseControler, 'Điều trị bệnh',
                  patienTemp.nameDisease.toString(), 'Tiểu Đường'),
              buildUserInfoDisplay(nameControler, 'Tên bệnh nhân',
                  patienTemp.getName, 'Nguyễn Kièu Anh'),
              buildUserInfoDisplay(
                  identityCardControler,
                  'CMMN/CCCD',
                  '${patienTemp.getID}',
                  '22210003857637',
                  TextInputType.number),
              buildUserInfoDisplay(phoneController, 'Số điện thoại',
                  patienTemp.getPhoneNum, '0348807912', TextInputType.number),
              buildUserInfoDisplay(
                  genderController,
                  'Giới Tính',
                  '${patienTemp.gender == 'unknow' ? '' : patienTemp.gender.toString()}',
                  'Nữ'),
              buildUserInfoDisplay(dateController, 'Ngày Sinh',
                  patienTemp.getBirthday, '04/01/2001', TextInputType.datetime),
            ],
          ),
        ),
      ),
    );
  }

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(TextEditingController editControler, String title,
      String value, String hint,
      [TextInputType textInput = TextInputType.text]) {
    editControler.text = value;
    return Padding(
        padding: EdgeInsets.only(bottom: 10, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            TextFormField(
              keyboardType: textInput,
              controller: editControler,
              cursorColor: Colors.black,
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 11),
                  hintText: "$hint"),
            ),
            Container(
              color: Colors.grey[400],
              height: 1,
              width: widthDevideMethod(0.85),
            ),
          ],
        ));
  }

  Future<void> _pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image != null) {
        return;
      }
      // final imageTemporary = File(image!.path);
      setState(() {
        this._image = File(image!.path);
      });
    } catch (e) {
      print("Failed to pick image: $e");
    }
  }

  Future<void> getLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      this._image = File(response.file!.path);
    } else {
      // _handleError(response.exception);
    }
  }

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
}
