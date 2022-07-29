import 'package:flutter/material.dart';
import 'package:medical_app/medical_home_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: Container(
        child: Center(
          child: InkWell(
              child: const Text('CLick!'),
              onTap: () => setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MedicalHomeScreen()),
                    );
                  })),
        ),
      ),
    );
  }
}
