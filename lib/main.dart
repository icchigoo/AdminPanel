// ignore_for_file: prefer_const_constructors

import 'package:admin_panel/screens/admin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  // These two lines
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Admin(),
    );
  }
}
