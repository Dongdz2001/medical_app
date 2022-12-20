import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/authentication/login/login.dart';
import 'package:medical_app/home/home_screen_main_login.dart';
import 'package:medical_app/sizeDevide.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'manage_patient/manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter app',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          headline2: TextStyle(fontSize: 18.0, color: Colors.black),
          bodyText2: TextStyle(fontSize: 20.0, fontFamily: 'Hind'),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String keyLocalLogin;
  final String keyCodeLocal;
  const MyHomePage(
      {Key? key,
      required this.title,
      required this.keyLocalLogin,
      required this.keyCodeLocal})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String keyLocalLogin = "";
  String keyCodeLocal = "";
  late Future<String> _fetchData;

  @override
  void initState() {
    _fetchData = getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widthDevide = MediaQuery.of(context).size.width;
    heightDevide = MediaQuery.of(context).size.height;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return FutureBuilder(
        future: _fetchData,
        builder: (context, snapshot) {
          Widget children;
          children = keyLocalLogin == ""
              ? Login()
              : HomeScreenMainLogin(
                  keyLogin: keyLocalLogin,
                  keyCode: keyCodeLocal,
                );
          return Container(
            child: children,
          );
        });
  }

  Future<String> getData() async {
    keyLocalLogin = this.widget.keyLocalLogin;

    if (keyLocalLogin != "") {
      await Manager(key: keyLocalLogin).readNameUser();
      await Manager(key: keyLocalLogin).readNameEmailUser();
      keyCodeLocal = this.widget.keyCodeLocal;
      if (keyCodeLocal != "") {
        // String keyLoginCreatorTemp = '';
        await FirebaseFirestore.instance
            .collection(keyCodeLocal)
            .doc('informationGroup')
            .get()
            .then((DocumentSnapshot value) async {
          Manager(key: keyLocalLogin).nameGroupJoin =
              await value['name_group'] ?? 'none';
        });
        // keyLoginCreatorTemp = value['keylogin_of_creator'] ?? 'error keylocal';
        // print("nameGroupCreator: ${value['keylogin_of_creator']}");
        Manager(key: keyLocalLogin).keyCodeGroup = keyCodeLocal;
        // await Manager(key: keyLocalLogin).readDataFireStoreDBManager();
      }
    }
    return "done";
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      String keyLocalLogin = "";
      String keyCodeLocal = "";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      keyLocalLogin = await prefs.getString('keyLocalLogin') ?? "";
      if (keyLocalLogin != "") {
        keyCodeLocal = await prefs.getString('keyCodeLocal') ?? "";
      }
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => MyHomePage(
                title: 'Medicial Home',
                keyCodeLocal: keyCodeLocal,
                keyLocalLogin: keyLocalLogin,
              )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 77, 77, 232),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // logo here
            Container(
              width: 120,
              height: 120,
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 219, 228, 226),
              ),
              child: Image.asset('assets/images/doctor_lagre.png'),
            ),
            const SizedBox(
              height: 70,
              width: 70,
            ),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
