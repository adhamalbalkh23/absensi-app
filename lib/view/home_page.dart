import 'dart:async';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = DateTime.now();
      });
    });
  }

  String getGreeting() {
    final hour = currentTime.hour;
    if (hour < 12) return "Good Morning";
    if (hour < 18) return "Good Afternoon";
    return "Good Evening";
  }

  String formatTime() {
    return "${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEDEDF2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
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

              const SizedBox(height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Marcus"),
                  Text(
                    formatTime(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
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
                      onPressed: () {},
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

              /// PROGRESS
              const Text(
                "Kehadiran Bulan Ini",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  LinearProgressIndicator(value: 0.8),
                  SizedBox(height: 5),
                  Text("80%"),
                ],
              ),

              const SizedBox(height: 20),

              /// QUICK MENU
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Icon(Icons.history),
                  Icon(Icons.person),
                  Icon(Icons.logout),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
