import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  GoogleMapController? mapController;

  LatLng currentLatLng = const LatLng(-6.200000, 106.816666); // default Jakarta
  String currentAddress = "Mendeteksi lokasi...";
  String currentTime = "";
  String currentDate = "";

  Timer? timer;

  @override
  void initState() {
    super.initState();
    getLocation();
    startClock();
  }

  /// ================= GET LOCATION =================
  Future<void> getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      currentLatLng = LatLng(position.latitude, position.longitude);
      currentAddress =
          "${position.latitude}, ${position.longitude}"; // bisa diganti geocoding
    });

    mapController?.animateCamera(CameraUpdate.newLatLngZoom(currentLatLng, 16));
  }

  /// ================= CLOCK =================
  void startClock() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();

      setState(() {
        currentTime = DateFormat("hh:mm a").format(now);
        currentDate = DateFormat("EEEE, MMM d").format(now);
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// GOOGLE MAP
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentLatLng,
              zoom: 14,
            ),
            onMapCreated: (controller) {
              mapController = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),

          /// GPS INFO
          Positioned(
            top: 60,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text("GPS PRECISION: 5M"),
            ),
          ),

          /// MARKER ICON
          Center(
            child: Icon(Icons.location_pin, size: 60, color: Colors.blue[900]),
          ),

          /// BOTTOM CARD
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TIME
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currentTime,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1A237E),
                        ),
                      ),
                      const Icon(Icons.access_time),
                    ],
                  ),

                  Text(currentDate),

                  const SizedBox(height: 20),

                  /// LOCATION BOX
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xffF3F3F7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.green),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            currentAddress,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        print("Check-in dikirim");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1A237E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Confirm Check-In"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
