import 'package:flutter/material.dart';
import 'package:insertrealtimedb/realtime_db/display.dart';
import 'package:insertrealtimedb/realtime_db/insert.dart';
import 'package:firebase_core/firebase_core.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.00),
            child: Column(
              children: [
                Text(
                  'Realtime Database',
                  style: TextStyle(color: Colors.orange, fontSize: 30),
                ),
                SizedBox(
                  height: 15,
                ),
                allButton('Điền thông tin', RealtimeDatabaseInsert()),
                SizedBox(
                  height: 15,
                ),
                allButton('Hiển thị thông tin', RealtimeDatabase()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget allButton(String text, var pageName) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => pageName));
      },
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
