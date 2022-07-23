import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_app/sizeDevide.dart';

class MedicalHomeScreen extends StatelessWidget {
  const MedicalHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 20, top: 20),
            child: const Text(
              'Phác đồ hiện tại: \n NUÔI DƯỠNG ĐƯỜNG TĨNH MẠCH ',
              style: TextStyle(
                  fontSize: 23, fontWeight: FontWeight.bold, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            height: heightDevideMethod(0.42),
            child: Stack(
              children: [
                SizedBox(
                  height: heightDevideMethod(0.4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: widthDevideMethod(0.1),
                      ),
                      SizedBox(
                          width: widthDevideMethod(0.7),
                          child: Image.asset("assets/doctor.jpg",
                              fit: BoxFit.fitHeight)),
                      Expanded(child: Container(color: Color(0xfff5f6f6))),
                    ],
                  ),
                ),
                Positioned(
                  bottom: heightDevideMethod(0.015),
                  left: 10,
                  child: Container(
                    width: widthDevideMethod(0.91),
                    height: heightDevideMethod(0.25),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/bbchat1.png"),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                            'Hello World')) /* add child content here */,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              SizedBox(width: widthDevideMethod(0.06)),
              const Text(
                'Nhập nồng độ glucozơ : ',
                style: TextStyle(fontSize: 20),
              ),
              Container(
                width: 80,
                height: 40,
                child: TextField(
                  maxLength: 5,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                  ],
                  decoration: InputDecoration(
                    counter: Offstage(),
                  ),
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
          SizedBox(height: heightDevideMethod(0.02)),
          Container(
            color: Colors.amberAccent,
            child: Text(
              'Thông tin bệnh nhân: ',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
