import 'dart:async';
import 'dart:convert';
import 'package:absensi_apps/api/chekin.dart';
import 'package:absensi_apps/api/endpoint.dart';
import 'package:absensi_apps/config/app_config.dart';
import 'package:absensi_apps/models/history_model.dart';
import 'package:absensi_apps/prefernce.dart';
import 'package:absensi_apps/view/riwayat_absensi.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:absensi_apps/api/checkout.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

String apiTime = "";

class _CheckInPageState extends State<CheckInPage> {
  String? attendanceDate;
  bool sudahCheckIn = false;
  bool sudahCheckOut = false;
  bool isTelat = false; // 🔥 STATUS TELAT
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
    cekAbsenHariIni();
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

    // 🔥 REVERSE GEOCODING - Konversi koordinat jadi alamat
    String address = "${position.latitude}, ${position.longitude}";
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        address =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}";
      }
    } catch (e) {
      print("Geocoding error: $e");
      // Fallback ke koordinat jika geocoding gagal
      address = "${position.latitude}, ${position.longitude}";
    }

    setState(() {
      currentLatLng = LatLng(position.latitude, position.longitude);
      currentAddress = address;
    });

    mapController?.animateCamera(CameraUpdate.newLatLngZoom(currentLatLng, 16));
  }

  /// ================= CLOCK =================
  void startClock() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();

      setState(() {
        /// 🔥 FORMAT UI (boleh tetap 12 jam)
        currentTime = DateFormat("hh:mm a").format(now);

        /// 🔥 FORMAT API (WAJIB 24 jam)
        apiTime =
            "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

        currentDate = DateFormat("EEEE, MMM d").format(now);

        /// 🔥 CEK APAKAH TELAT (check-in setelah 08:00)
        isTelat =
            now.hour > AppConfig.maxCheckInHour ||
            (now.hour == AppConfig.maxCheckInHour &&
                now.minute >= AppConfig.maxCheckInMinute);
      });
    });
  }

  Future<void> cekAbsenHariIni() async {
    final token = await PreferenceHandler().getToken() ?? "";

    final response = await http.get(
      Uri.parse(Endpoint.getAbsensi),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    final data = jsonDecode(response.body);

    print("ABSEN TODAY FULL: $data");

    if (data['data'] != null && data['data'] is Map) {
      final absen = data['data'];

      print("ATTENDANCE DATE: ${absen['attendance_date']}");

      setState(() {
        attendanceDate = absen['attendance_date'];
        sudahCheckIn = absen['check_in_time'] != null;
        sudahCheckOut = absen['check_out_time'] != null;
      });
    }
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
      backgroundColor: const Color(0xffF5F6FA),
      body: Column(
        children: [
          /// GOOGLE MAP IN CONTAINER
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[300]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            margin: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  /// MAP
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

                  /// GPS INFO BADGE
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: const Text(
                        "📍 GPS PRECISION: 5M",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1A237E),
                        ),
                      ),
                    ),
                  ),

                  /// CENTER MARKER
                  Center(
                    child: Icon(
                      Icons.location_pin,
                      size: 50,
                      color: Colors.blue[900],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// BOTTOM SCROLLABLE CONTENT
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        const Icon(Icons.access_time, color: Color(0xff1A237E)),
                      ],
                    ),

                    Text(
                      currentDate,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),

                    const SizedBox(height: 20),

                    /// LOCATION BOX
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!, width: 1),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.green),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              currentAddress,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// STATUS BADGES
                    Row(
                      children: [
                        /// CHECK-IN STATUS
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: sudahCheckIn
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: sudahCheckIn ? Colors.green : Colors.red,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              sudahCheckIn
                                  ? "✓ Sudah Check-In"
                                  : "✗ Belum Check-In",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: sudahCheckIn ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        /// CHECK-OUT STATUS
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: sudahCheckOut
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: sudahCheckOut
                                    ? Colors.green
                                    : Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              sudahCheckOut
                                  ? "✓ Sudah Check-Out"
                                  : "○ Belum Check-Out",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: sudahCheckOut
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// STATUS TELAT BADGE (jika sudah lewat 08:00)
                    if (isTelat)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange, width: 1),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.warning, color: Colors.orange, size: 20),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Perhatian: Check-in Anda akan dihitung TELAT",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),

                    /// BUTTON CHECK-IN
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: sudahCheckIn
                            ? null
                            : () async {
                                print("BUTTON CHECK-IN DIKLIK");
                                final token =
                                    await PreferenceHandler().getToken() ?? "";
                                print("TOKEN: $token");

                                final success = await checkInApi(
                                  token: token,
                                  lat: currentLatLng.latitude,
                                  lng: currentLatLng.longitude,
                                  address: currentAddress,
                                );

                                if (!mounted) return;

                                if (success) {
                                  final newHistory = HistoryModel(
                                    time: currentTime,
                                    date: currentDate,
                                    location: currentAddress,
                                  );

                                  await PreferenceHandler().addHistory(
                                    newHistory,
                                  );

                                  setState(() {
                                    sudahCheckIn = true;
                                  });

                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("✓ Check-in berhasil"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("✗ Check-in gagal"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: sudahCheckIn
                              ? Colors.grey
                              : const Color(0xff1A237E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          sudahCheckIn ? "Sudah Check-In" : "Confirm Check-In",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// BUTTON CHECK-OUT
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: !sudahCheckIn || sudahCheckOut
                            ? null
                            : () async {
                                print("BUTTON CHECK-OUT DIKLIK");

                                final token =
                                    await PreferenceHandler().getToken() ?? "";
                                print("TOKEN: $token");

                                await cekAbsenHariIni(); // 🔥 TAMBAH INI

                                print(
                                  "ATTENDANCE DATE: $attendanceDate",
                                ); // 🔥 DEBUG

                                if (attendanceDate == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Data absensi belum siap"),
                                    ),
                                  );
                                  return;
                                }

                                final success = await checkOutApi(
                                  token: token,
                                  attendanceDate: attendanceDate!,
                                  lat: currentLatLng.latitude,
                                  lng: currentLatLng.longitude,
                                  address: currentAddress,
                                );

                                if (!mounted) return;

                                if (success) {
                                  setState(() {
                                    sudahCheckOut = true;
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("✓ Check-out berhasil"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("✗ Check-out gagal"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: sudahCheckOut
                              ? Colors.grey
                              : Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          sudahCheckOut
                              ? "Sudah Check-Out"
                              : "Confirm Check-Out",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
