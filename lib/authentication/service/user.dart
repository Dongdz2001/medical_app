import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login/home_screen.dart';

class UserManagement {
  storeNewUser(user, context) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .set({'email': user.email, 'uid': user.uid})
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
