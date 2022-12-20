import 'package:flutter/material.dart';

class LanguageSettingScreen extends StatefulWidget {
  const LanguageSettingScreen({Key? key}) : super(key: key);

  @override
  _LanguageSettingScreenState createState() => _LanguageSettingScreenState();
}

class _LanguageSettingScreenState extends State<LanguageSettingScreen> {
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
            "Language Setting",
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
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                // List Settings Menu

                // Language
                Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 8),
                    color: Colors.white,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: ListTile(
                        title: Text(
                          'Language',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                    )),
                // Language English
                Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 8),
                    color: Colors.white,
                    height: 60,
                    child: ListTile(
                      trailing: Transform(
                        // you can forcefully translate values left side using Transform
                        transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                        child: GestureDetector(
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 21,
                          ),
                          // onTap: () => Navigator.pop(context),
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.headline4,
                            children: [
                              WidgetSpan(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 19, right: 125),
                                  child: Text(
                                    'Language',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "poppins",
                                        color: Color(0xFF393939)),
                                  ),
                                ),
                              ),
                              WidgetSpan(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 19),
                                  child: Text(
                                    'English',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "poppins",
                                        fontWeight: FontWeight.w500),
                                    // textDirection: TextDirection.ltr,
                                  ),
                                ),
                              ),
                              WidgetSpan(
                                child: Text(
                                  ' (United\nStates)',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "poppins",
                                      color: Color(0xFFA6A1A1),
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
