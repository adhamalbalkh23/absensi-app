import 'dart:async';
import 'dart:convert';
import 'package:absensi_apps/api/profile.dart';
import 'package:absensi_apps/view/chekin_page.dart';
import 'package:absensi_apps/prefernce.dart';
import 'package:absensi_apps/api/endpoint.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime currentTime = DateTime.now();

  // 🔥 STATISTIK ABSENSI
  int hadir = 0;
  int izin = 0;
  int absen = 0;

  // 🔥 DATA USER
  String userName = "User";

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = DateTime.now();
      });
    });

    loadUserName();
    loadStatistikAbsensi();
  }

  /// ================= LOAD USER NAME =================
  Future<void> loadUserName() async {
    final token = await PreferenceHandler().getToken() ?? "";

    try {
      final data = await getProfile(token);

      if (data != null) {
        setState(() {
          userName = data['name'] ?? "User";
        });
        print("USER NAME: $userName");
      }
    } catch (e) {
      print("ERROR LOAD USER NAME: $e");
    }
  }

  /// ================= LOAD STATISTIK ABSENSI =================
  Future<void> loadStatistikAbsensi() async {
    final token = await PreferenceHandler().getToken() ?? "";

    try {
      final response = await http.get(
        Uri.parse(Endpoint.history),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("STATUS STATISTIK: ${response.statusCode}");
      print("BODY STATISTIK: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['data'] != null && data['data'] is List) {
          final historyList = data['data'] as List;

          // 🔥 HITUNG STATISTIK
          int countHadir = 0;
          int countIzin = 0;
          int countAbsen = 0;

          for (var item in historyList) {
            final status = item['status']?.toString().toLowerCase() ?? "";

            if (status == "hadir" || status == "masuk") {
              countHadir++;
            } else if (status == "izin") {
              countIzin++;
            } else if (status == "absen") {
              countAbsen++;
            }
          }

          setState(() {
            hadir = countHadir;
            izin = countIzin;
            absen = countAbsen;
          });

          print("STATISTIK - Hadir: $hadir, Izin: $izin, Absen: $absen");
        }
      }
    } catch (e) {
      print("ERROR STATISTIK: $e");
    }
  }

  String getGreeting() {
    final hour = currentTime.hour;
    String greeting = "";

    if (hour < 12) {
      greeting = "Good Morning";
    } else if (hour < 18) {
      greeting = "Good Afternoon";
    } else {
      greeting = "Good Evening";
    }

    return "$greeting, $userName";
  }

  String formatTime() {
    return "${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEDEDF2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                const Text(
                  "PPKD JAKPUS",
                  style: TextStyle(
                    color: Color(0xff2D3A8C),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  getGreeting(),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1A237E),
                  ),
                ),

                const SizedBox(height: 10),

                /// LOKASI
                Row(
                  children: const [
                    Icon(Icons.location_on, size: 16, color: Colors.grey),
                    SizedBox(width: 5),
                    Text("PPKD Jakarta Pusat"),
                  ],
                ),

                const SizedBox(height: 20),

                /// CARD CHECK IN
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xff1A237E), Color(0xff283593)],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(Icons.login, color: Colors.white),
                          Text(
                            "SYSTEM READY",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Check In",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        "Start your daily session",
                        style: TextStyle(color: Colors.white70),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CheckInPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xff1A237E),
                        ),
                        child: const Text("Check In"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// STATUS
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Sudah Check In",
                    style: TextStyle(color: Colors.green),
                  ),
                ),

                const SizedBox(height: 20),

                /// STATISTIK ABSENSI
                const Text(
                  "Statistik Absensi",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1A237E),
                  ),
                ),

                const SizedBox(height: 12),

                /// STATISTIK CARDS
                Row(
                  children: [
                    /// HADIR
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.green, width: 2),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 28,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Hadir",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "$hadir",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    /// IZIN
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.blue, width: 2),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.blue,
                              size: 28,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Izin",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "$izin",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    /// ABSEN
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.red, width: 2),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.cancel,
                              color: Colors.red,
                              size: 28,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Absen",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "$absen",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// INFO CARD
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: const [
                            Text("Last Check In"),
                            SizedBox(height: 5),
                            Text(
                              "09:12 AM",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1A237E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: const [
                            Text("Scheduled Out"),
                            SizedBox(height: 5),
                            Text(
                              "05:30 PM",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1A237E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
