import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class RealtimeDatabase extends StatefulWidget {
  const RealtimeDatabase({Key? key}) : super(key: key);

  @override
  State<RealtimeDatabase> createState() => _RealtimeDatabaseState();
}

class _RealtimeDatabaseState extends State<RealtimeDatabase> {
  final databaseRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FirebaseAnimatedList(query: databaseRef,
              itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index){
            return ListTile(
              title: Text("Object ${index}"),onTap: (){
                setState(() {
                  // Map<dynamic, dynamic> map = snapshot.key;
                  // if (snapshot.exists) {
                    Object? values = snapshot.value as Map<Object,dynamic>;
                    print(values.toString());
                  //   values.forEach((key, value) {
                  //     print(key);
                  //   });
                  // } else {
                  //   print('No data available.1');-
                  // }
                  print(snapshot.toString());
                  // map.values.toList()[index]['name'];
                });
            },
            );
              })

      ),
    );
  }
}

