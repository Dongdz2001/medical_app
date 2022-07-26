import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class addnote extends StatefulWidget {
  @override
  _addnoteState createState() => _addnoteState();
}

class _addnoteState extends State<addnote> {
  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final gluController = TextEditingController();

  final fb = FirebaseDatabase.instance;
  @override
  Widget build(BuildContext context) {
    var rng = Random();
    var k = rng.nextInt(10000);

    final ref = fb.ref().child('Users/$k');

    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm bệnh nhân"),
        backgroundColor: Colors.indigo[900],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Insert data',
                style: TextStyle(fontSize: 28),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Tên',
                    border: OutlineInputBorder(),
                  )),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                  controller: genderController,
                  decoration: InputDecoration(
                    labelText: 'Giới tính',
                    border: OutlineInputBorder(),
                  )),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                  controller: ageController,
                  decoration: InputDecoration(
                    labelText: 'Năm Sinh',
                    border: OutlineInputBorder(),
                  )),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                  controller: heightController,
                  decoration: InputDecoration(
                    labelText: 'Chiều cao',
                    border: OutlineInputBorder(),
                  )),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                  controller: weightController,
                  decoration: InputDecoration(
                    labelText: 'Cân nặng',
                    border: OutlineInputBorder(),
                  )),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                  controller: gluController,
                  decoration: InputDecoration(
                    labelText: 'Glu mmol/l',
                    border: OutlineInputBorder(),
                  )),
              SizedBox(
                height: 30,
              ),
              MaterialButton(
                color: Colors.indigo[900],
                onPressed: () {
                  ref.set({
                    "Tên": nameController.text,
                    "Giới tính": genderController.text,
                    "Năm sinh": ageController.text,
                    "Chiều cao": heightController.text,
                    "Cân nặng": weightController.text,
                    "Glu": gluController.text
                  }).asStream();
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => Home()));
                },
                child: Text(
                  "save",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
