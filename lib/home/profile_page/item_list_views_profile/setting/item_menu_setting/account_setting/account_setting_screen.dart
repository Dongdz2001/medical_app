import 'package:flutter/material.dart';

class AccountSettingScreen extends StatelessWidget {
  const AccountSettingScreen({Key? key}) : super(key: key);

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
            "Account Settings",
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

                // Security
                InkWell(
                  // onTap: () => Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => AccountSettingScreen())),
                  child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(bottom: 8),
                      color: Colors.white,
                      height: 70,
                      child: ListTile(
                        leading: ImageIcon(
                          AssetImage("assets/icons/security.png"),
                          color: Color(0xFF69A03A),
                          size: 36,
                        ),
                        title: Text(
                          'Security',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      )),
                ),
                SizedBox(height: 2),
                // Deactivate Account
                Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 8),
                    color: Colors.white,
                    height: 70,
                    child: ListTile(
                      leading: ImageIcon(
                        AssetImage("assets/icons/deactivate_account.png"),
                        color: Color(0xFF69A03A),
                        size: 36,
                      ),
                      title: Text(
                        'Deactivate Account',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    )),
                SizedBox(height: 2),
                //Delete Account
                InkWell(
                  child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(bottom: 8),
                      color: Colors.white,
                      height: 70,
                      child: ListTile(
                        leading: ImageIcon(
                          AssetImage("assets/icons/delete_account.png"),
                          color: Color(0xFF69A03A),
                          size: 36,
                        ),
                        title: Text(
                          'Delete Account',
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
