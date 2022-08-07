import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_app/sizeDevide.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({Key? key}) : super(key: key);

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff091a31),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15, right: 20),
            child: const Text('Lưu'),
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
              buildUserInfoDisplay(
                  'Tên bệnh nhân', 'Nguyễn Kièu Anh', 'Nguyễn Kièu Anh'),
              buildUserInfoDisplay(
                  'CMMN/CCCD', '22210003857637', '22210003857637'),
              buildUserInfoDisplay('Số Điện Thoại', '0348807912', '0348807912'),
              buildUserInfoDisplay('Giới Tính', 'Nữ', 'Nữ'),
              buildUserInfoDisplay('Ngày Sinh', '04/01/2001', '04/01/2001'),
            ],
          ),
        ),
      ),
    );
  }

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(String title, String value, String hint) {
    TextEditingController editControler = TextEditingController();
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
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
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
}
