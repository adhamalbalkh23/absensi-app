import 'package:absensi_apps/view/home_page.dart';
import 'package:absensi_apps/view/profile_page.dart';
import 'package:absensi_apps/view/riwayat_absensi.dart';
import 'package:flutter/material.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'dart:ui';

class Navbarpage extends StatefulWidget {
  const Navbarpage({super.key});

  @override
  State<Navbarpage> createState() => _NavbarpageState();
}

class _NavbarpageState extends State<Navbarpage> {
  int _currentIndex = 0;

  final List<Widget> _pagesList = [HomePage(), HistoryPage(), ProfilePage()];

  void _handleIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pagesList[_currentIndex],
      backgroundColor: Color(0xFF0F172A),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(15),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: CrystalNavigationBar(
              currentIndex: _currentIndex,
              unselectedItemColor: const Color.fromARGB(179, 20, 20, 20),
              backgroundColor: Colors.black.withOpacity(0.1),
              borderWidth: 1,
              outlineBorderColor: Colors.white,
              onTap: _handleIndexChanged,
              items: [
                CrystalNavigationBarItem(
                  icon: Icons.home,
                  selectedColor: Colors.blueAccent,
                ),
                CrystalNavigationBarItem(
                  icon: Icons.history,
                  selectedColor: Colors.blueAccent,
                ),
                CrystalNavigationBarItem(
                  icon: Icons.person,
                  selectedColor: Colors.blueAccent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
