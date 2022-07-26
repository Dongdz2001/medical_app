import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:insertrealtimedb/realtime_db/addnode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Danh sách bệnh nhân",
      theme: ThemeData(
        primaryColor: Colors.greenAccent[700],
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final fb = FirebaseDatabase.instance;
  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final gluController = TextEditingController();
  var l;
  var g;
  var k;

  @override
  Widget build(BuildContext context) {
    final ref = fb.ref().child('Users');

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo[900],
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => addnote(),
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Danh sách bệnh nhân',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.indigo[900],
      ),
      body: FirebaseAnimatedList(
        query: ref,
        shrinkWrap: true,
        itemBuilder: (context, snapshot, animation, index) {
          var v =
              snapshot.value.toString(); // {subtitle: webfun, title: subscribe}

          g = v.replaceAll(
              RegExp(
                  "{|}|giới tính: {|}|tên: {|}|tuổi: {|}|chiều cao:{|}|cân nặng: {|}|glu:{|}|"),
              ""); // webfun, subscribe
          g.trim();

          l = g.split(','); // [webfun,  subscribe}]

          return GestureDetector(
            onTap: () {
              setState(() {
                k = snapshot.key;
              });

              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: TextField(
                      controller: nameController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Tên',
                      ),
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(border: Border.all()),
                          child: TextField(
                            controller: genderController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'Giới tính',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(border: Border.all()),
                          child: TextField(
                            controller: ageController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'Năm sinh',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(border: Border.all()),
                          child: TextField(
                            controller: heightController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'Chiều cao',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(border: Border.all()),
                          child: TextField(
                            controller: weightController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'Cân nặng',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(border: Border.all()),
                          child: TextField(
                            controller: gluController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'glu',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      color: Color.fromARGB(255, 0, 22, 145),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        await upd();
                        Navigator.of(ctx).pop();
                      },
                      color: Color.fromARGB(255, 0, 22, 145),
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tileColor: Colors.indigo[100],
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Color.fromARGB(255, 255, 0, 0),
                      ),
                      onPressed: () {
                        ref.child(snapshot.key!).remove();
                      },
                    ),
                    title: Column(children: [
                      Text(
                        l[4],
                        // 'dd',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        l[1],
                        // 'dd',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        l[3],
                        // 'dd',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        l[0],
                        // 'dd',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        l[5],
                        // 'dd',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        l[2],
                        // 'dd',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ])),
              ),
            ),
          );
        },
      ),
    );
  }

  upd() async {
    DatabaseReference ref1 = FirebaseDatabase.instance.ref("Users/$k");

// Only update the name, leave the age and address!
    await ref1.update({
      "Tên": nameController.text,
      "Giới tính": genderController.text,
      "Năm sinh": ageController.text,
      "Chiều cao": heightController.text,
      "Cân nặng": weightController.text,
      "Glu": gluController.text
    });
    nameController.clear();
    genderController.clear();
    ageController.clear();
    heightController.clear();
    weightController.clear();
    gluController.clear();
  }
}
