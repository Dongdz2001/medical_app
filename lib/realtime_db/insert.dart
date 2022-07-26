import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeDatabaseInsert extends StatefulWidget {
  const RealtimeDatabaseInsert({Key? key}) : super(key: key);

  @override
  State<RealtimeDatabaseInsert> createState() => _RealtimeDatabaseInsertState();
}

class _RealtimeDatabaseInsertState extends State<RealtimeDatabaseInsert> {
  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final gluController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: 15000,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                        labelText: 'Name',
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
                  OutlinedButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty &&
                          ageController.text.isNotEmpty &&
                          genderController.text.isNotEmpty &&
                          heightController.text.isNotEmpty &&
                          weightController.text.isNotEmpty &&
                          gluController.text.isNotEmpty) {
                        insertData(
                            nameController.text,
                            genderController.text,
                            ageController.text,
                            heightController.text,
                            weightController.text,
                            gluController.text);
                      }
                    },
                    child: Text('Add', style: TextStyle(fontSize: 18)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void insertData(String name, String gender, String age, String height,
      String weight, String glu) {
    String? key = databaseRef.child('Users').push().key;
    databaseRef.child('Users').child(key!).set({
      'id': key,
      'name': name,
      'gender': gender,
      'age': age,
      'height': height,
      'weight': weight,
      'glu': glu
    });
    nameController.clear();
    genderController.clear();
    ageController.clear();
    heightController.clear();
    weightController.clear();
    gluController.clear();
  }
}
