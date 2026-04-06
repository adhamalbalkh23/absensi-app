import 'package:absensi_apps/extension/navigator.dart';
import 'package:absensi_apps/liquid_navbar.dart';
import 'package:absensi_apps/prefernce.dart';
import 'package:absensi_apps/view/login_page.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    autoLogin();
  }

  void autoLogin() async {
    await Future.delayed(Duration(seconds: 5));
    bool? data = await PreferenceHandler().getIsLogin();
    if (data == true) {
      context.pushAndRemoveAll(Navbarpage());
    } else {
      context.pushAndRemoveAll(LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "assets/images/backgroundabsen.png",
              fit: BoxFit.cover,
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo goabsen.png",
                  height: 316,
                  width: 316,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
