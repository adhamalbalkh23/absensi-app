import 'package:absensi_apps/liquid_navbar.dart';
import 'package:absensi_apps/view/home_page.dart';
import 'package:absensi_apps/view/login_page.dart';
import 'package:absensi_apps/view/splashscreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blueAccent)),
      home: SplashPage(),
    );
  }
}
