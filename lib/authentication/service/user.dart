import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../home/person_home_screen.dart';

class UserManagement {
  storeNewUser(user, BuildContext context) async {
    assert(user != null);
    var firebaseUser = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .set({'email': user.user!.email, 'uid': user.user!.uid})
        .then((value) => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                      keyLogin: user.user!.uid.toString(),
                    ))))
        .catchError((e) {
          // ignore: avoid_print
          print(e);
        });
  }
}
