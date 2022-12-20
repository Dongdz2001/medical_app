import 'package:flutter/material.dart';

class ChangeAddressSettingScreen extends StatelessWidget {
  const ChangeAddressSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF69A03A),
        title: Transform(
          // you can forcefully translate values left side using Transform
          transform: Matrix4.translationValues(-30.0, 17.0, 0.0),
          child: Text(
            "Change Address Setting",
            style: TextStyle(
              fontFamily: "poppins",
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        leading: Transform(
          // you can forcefully translate values left side using Transform
          transform: Matrix4.translationValues(0.0, 20.0, 0.0),
          child: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              size: 21,
            ),
            onTap: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 20,
              color: Color(0xFF69A03A),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  // List Settings Menu

                  // Language
                  Container(
                      padding: EdgeInsets.only(bottom: 8),
                      color: Colors.white,
                      height: 60,
                      child: ListTile(
                        title: Text(
                          'Address',
                          style: TextStyle(
                            fontFamily: "poppins",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )),
                  Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      minLines: 5,
                      maxLines: null,
                      // remove underline text when type character in textfeild
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 2.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 2.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText:
                            'D Block Nagar Near Sai Petrol\nPump Ring Road Negapur-440001.',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 10),
                    child: SizedBox(
                      width: 335,
                      height: 52,
                      child: ElevatedButton(
                          onPressed: () {
                            // Navigator.of(context).pushReplacement(
                            //     MaterialPageRoute(
                            //         builder: (_) => HomeMainScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF69A03A),
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(12.0),
                            ),
                          ),
                          child: Text(
                            "Change",
                            style: TextStyle(
                              fontFamily: "poppins",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
