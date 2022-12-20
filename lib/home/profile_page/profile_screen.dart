import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/authentication/login/login.dart';
import 'package:medical_app/home/history_pateint_screen.dart';
import 'package:medical_app/manage_patient/manager.dart';
import 'package:medical_app/sizeDevide.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final String? keylogin;
  const ProfileScreen({Key? key, required this.keylogin}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String keylogin;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    keylogin = this.widget.keylogin!;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff091a31),
        title: const Text('Hồ sơ cá nhân'),
      ),
      backgroundColor: Color.fromARGB(255, 236, 234, 234),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: size.height * 0.25,
            width: widthDevideMethod(1),
            decoration: BoxDecoration(
              color: Color(0xff091a31),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: heightDevideMethod(0.04)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        padding: EdgeInsets.all(1),
                        child: ClipRRect(
                          borderRadius: new BorderRadius.circular(360.0),
                          child: Image(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/logoDoctor.png'),
                            width: size.width * 0.1,
                            height: size.width * 0.1,
                          ),
                        ),
                        width: size.width * 0.22,
                        height: size.width * 0.22,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(360),
                          color: Colors.white,
                        )),
                    SizedBox(width: widthDevideMethod(0.3)),
                    SizedBox(width: widthDevideMethod(0.06)),
                  ],
                ),
                SizedBox(height: heightDevideMethod(0.02)),
                Text("${Manager(key: keylogin).nameUser}",
                    style: TextStyle(color: Colors.white)),
                SizedBox(height: heightDevideMethod(0.01)),
                Container(
                  height: 20,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      "${Manager(key: keylogin).nameEmailUser}",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // List menu profile
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  // My Order
                  Container(
                      color: Colors.grey[600],
                      height: heightDevideMethod(0.002)),
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryPateintScreen(
                                  checkGroupOrPersonal: false,
                                  manager: Manager(key: keylogin),
                                ))),
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        color: Colors.white,
                        height: size.height * 0.074,
                        child: ListTile(
                          leading: Icon(
                            Icons.shopping_bag,
                            size: size.width * 0.075,
                            color: Color.fromARGB(255, 82, 162, 12),
                          ),
                          title: Text(
                            'Lưu trữ cá nhân',
                            style: TextStyle(color: Colors.black, fontSize: 22),
                          ),
                        )),
                  ),
                  Container(
                      color: Colors.grey[600],
                      height: heightDevideMethod(0.002)),
                  // Favourites
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryPateintScreen(
                                  checkGroupOrPersonal: true,
                                  manager: Manager(key: keylogin),
                                ))),
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        color: Colors.white,
                        height: size.height * 0.074,
                        child: ListTile(
                          leading: Icon(
                            Icons.favorite,
                            size: size.width * 0.075,
                            color: Color.fromARGB(255, 82, 162, 12),
                          ),
                          title: Text(
                            'Lưu trữ nhóm',
                            style: TextStyle(color: Colors.black, fontSize: 22),
                          ),
                        )),
                  ),
                  Container(
                      color: Colors.grey[600],
                      height: heightDevideMethod(0.002)),
                  // // Settings
                  // InkWell(
                  //   onTap: () => Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => SettingScreen())),
                  //   child: Container(
                  //       alignment: Alignment.bottomCenter,
                  //       color: Colors.white,
                  //       height: size.height * 0.074,
                  //       child: ListTile(
                  //         leading: Icon(
                  //           Icons.settings,
                  //           size: size.width * 0.075,
                  //           color: Color.fromARGB(255, 82, 162, 12),
                  //         ),
                  //         title: Text(
                  //           'Settings',
                  //           style: TextStyle(color: Colors.black, fontSize: 22),
                  //         ),
                  //       )),
                  // ),
                  // Container(
                  //     color: Colors.grey[600],
                  //     height: heightDevideMethod(0.002)),
                  // // My Cart
                  // Container(
                  //     alignment: Alignment.bottomCenter,
                  //     color: Colors.white,
                  //     height: size.height * 0.074,
                  //     child: ListTile(
                  //       leading: Icon(
                  //         Icons.shopping_cart,
                  //         size: size.width * 0.075,
                  //         color: Color.fromARGB(255, 82, 162, 12),
                  //       ),
                  //       title: Text(
                  //         'My Cart',
                  //         style: TextStyle(color: Colors.black, fontSize: 22),
                  //       ),
                  //     )),
                  // Container(
                  //     color: Colors.grey[600],
                  //     height: heightDevideMethod(0.002)),
                  // // Rate us
                  // Container(
                  //     alignment: Alignment.bottomCenter,
                  //     color: Colors.white,
                  //     height: size.height * 0.074,
                  //     child: ListTile(
                  //       leading: ImageIcon(
                  //         AssetImage("assets/images/logoDoctor.png"),
                  //         color: Color.fromARGB(255, 82, 162, 12),
                  //         size: 36,
                  //       ),
                  //       title: Text(
                  //         ' Rate us',
                  //         style: TextStyle(color: Colors.black, fontSize: 22),
                  //       ),
                  //     )),
                  // Container(
                  //     color: Colors.grey[600],
                  //     height: heightDevideMethod(0.002)),
                  // // Refer a Friend
                  // Container(
                  //     alignment: Alignment.bottomCenter,
                  //     color: Colors.white,
                  //     height: size.height * 0.074,
                  //     child: ListTile(
                  //       leading: Icon(
                  //         Icons.share,
                  //         size: size.width * 0.075,
                  //         color: Color.fromARGB(255, 82, 162, 12),
                  //       ),
                  //       title: Text(
                  //         'Refer a Friend',
                  //         style: TextStyle(color: Colors.black, fontSize: 22),
                  //       ),
                  //     )),
                  // Container(
                  //     color: Colors.grey[600],
                  //     height: heightDevideMethod(0.002)),

                  // Log Out
                  InkWell(
                    onTap: () async {
                      print("keyloginProfile: $keylogin");
                      await FirebaseAuth.instance.signOut();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString('keyLocalLogin', '');
                      prefs.setString('keyCodeLocal', '');

                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return Login();
                          },
                        ),
                        (_) => false,
                      );
                    },
                    child: Container(
                        alignment: Alignment.topCenter,
                        color: Colors.white,
                        child: ListTile(
                          leading: Icon(
                            Icons.logout_rounded,
                            size: size.width * 0.075,
                            color: Color.fromARGB(255, 82, 162, 12),
                          ),
                          title: Text(
                            'Log Out',
                            style: TextStyle(color: Colors.black, fontSize: 22),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  // Future<void> signOut() async {
  //   FacebookAuth
  //   await _facebookLogin.logOut();
  //   await _auth.signOut();
  //   _user = null;
  // }
}
