import 'package:flutter/material.dart';
import 'package:medical_app/home/profile_page/item_list_views_profile/setting/item_menu_setting/account_setting/account_setting_screen.dart';
import 'package:medical_app/home/profile_page/item_list_views_profile/setting/item_menu_setting/change_address_setting/change_address_setting_screen.dart';
import 'package:medical_app/home/profile_page/item_list_views_profile/setting/item_menu_setting/language_setting/language_setting_screen.dart';
import 'package:medical_app/home/profile_page/item_list_views_profile/setting/item_menu_setting/notification_setting/notification_setting_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 241, 241, 241),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF69A03A),
        title: Transform(
          // you can forcefully translate values left side using Transform
          transform: Matrix4.translationValues(-30.0, 17.0, 0.0),
          child: Text(
            "Settings",
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

                // Account
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AccountSettingScreen())),
                  child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(bottom: 8),
                      color: Colors.white,
                      height: 70,
                      child: ListTile(
                        leading: Icon(
                          Icons.account_circle_rounded,
                          size: 32,
                          color: Color(0xFF69A03A),
                        ),
                        title: Text(
                          'Account',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      )),
                ),
                SizedBox(height: 2),
                // Notification
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationSettingScreen())),
                  child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(bottom: 8),
                      color: Colors.white,
                      height: 70,
                      child: ListTile(
                        leading: Icon(
                          Icons.notifications,
                          size: 32,
                          color: Color(0xFF69A03A),
                        ),
                        title: Text(
                          'Notification',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      )),
                ),
                SizedBox(height: 2),
                //Language
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LanguageSettingScreen())),
                  child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(bottom: 8),
                      color: Colors.white,
                      height: 70,
                      child: ListTile(
                        leading: Icon(
                          Icons.language,
                          size: 32,
                          color: Color(0xFF69A03A),
                        ),
                        title: Text(
                          'Language',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      )),
                ),
                SizedBox(height: 2),
                // Change Address
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeAddressSettingScreen())),
                  child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(bottom: 8),
                      color: Colors.white,
                      height: 70,
                      child: ListTile(
                        leading: ImageIcon(
                          AssetImage("assets/icons/pin_home.png"),
                          color: Color(0xFF69A03A),
                          size: 36,
                        ),
                        // Icon(
                        //   Icons.pin,
                        //   size: 32,
                        //   color: Color(0xFF69A03A),
                        // ),
                        title: Text(
                          'Change Address',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      )),
                ),
                SizedBox(height: 2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
