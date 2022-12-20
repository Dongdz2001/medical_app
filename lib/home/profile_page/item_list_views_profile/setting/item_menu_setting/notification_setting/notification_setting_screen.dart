import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({Key? key}) : super(key: key);

  @override
  _NotificationSettingScreenState createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  bool isToggled1 = true;
  bool isToggled2 = false;
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
            "Notification Setting",
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

                // My Account
                Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 8),
                    color: Colors.white,
                    height: 70,
                    child: ListTile(
                      leading: Icon(
                        Icons.notifications,
                        size: 36,
                        color: Color(0xFF69A03A),
                      ),
                      trailing: Container(
                        width: 40,
                        height: 30,
                        child: FlutterSwitch(
                          height: 18.0,
                          width: 40.0,
                          padding: 4.0,
                          toggleSize: 10.0,
                          borderRadius: 20.0,
                          activeColor: Color(0xFF69A03A),
                          value: isToggled1,
                          onToggle: (value) {
                            setState(() {
                              isToggled1 = value;
                            });
                          },
                        ),
                      ),
                      title: Text(
                        'My Account',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      subtitle: Text(
                        "You will receive daily updates",
                        style: TextStyle(fontSize: 13),
                      ),
                    )),
                SizedBox(height: 2),
                // Pramotional Notifications
                Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 8),
                    color: Colors.white,
                    height: 70,
                    child: ListTile(
                      leading: Icon(
                        Icons.notifications,
                        size: 36,
                        color: Color(0xFF69A03A),
                      ),
                      trailing: Container(
                        width: 40,
                        height: 30,
                        child: FlutterSwitch(
                          height: 18.0,
                          width: 40.0,
                          padding: 4.0,
                          toggleSize: 10.0,
                          borderRadius: 20.0,
                          activeColor: Color(0xFF69A03A),
                          value: isToggled2,
                          onToggle: (value) {
                            setState(() {
                              isToggled2 = value;
                            });
                          },
                        ),
                      ),
                      title: Text(
                        'Pramotional Notifications',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      subtitle: Text(
                        "You will receive daily updates",
                        style: TextStyle(fontSize: 13),
                      ),
                    )),
                SizedBox(height: 2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


     // trailing: CupertinoSwitch(
                      //   value: _switchValue,
                      //   activeColor: Color(0xFF69A03A),

                      //   onChanged: (value) {
                      //     setState(() {
                      //       _switchValue = value;
                      //     });
                      //   },
                      // ),