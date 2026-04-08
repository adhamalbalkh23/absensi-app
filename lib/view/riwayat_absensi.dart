import 'package:absensi_apps/api/get_history.dart';
import 'package:flutter/material.dart';
import '../prefernce.dart';

class RiwayatAbsensi extends StatefulWidget {
  const RiwayatAbsensi({super.key});

  @override
  State<RiwayatAbsensi> createState() => _RiwayatAbsensiState();
}

class _RiwayatAbsensiState extends State<RiwayatAbsensi> {
  List historyList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final token = await PreferenceHandler().getToken() ?? "";

    final data = await getHistory(token);

    print("HISTORY DATA: $data"); // 🔥 DEBUG

    setState(() {
      historyList = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      appBar: AppBar(
        title: const Text("Riwayat Absensi"),
        backgroundColor: const Color(0xff1A237E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : historyList.isEmpty
          ? const Center(child: Text("Belum ada data"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final item = historyList[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      /// ICON
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.login,
                          color: Color(0xff1A237E),
                        ),
                      ),

                      const SizedBox(width: 16),

                      /// TEXT
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// CHECK-IN TIME
                            Row(
                              children: [
                                const Text(
                                  "Check-In: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  item['check_in_time'] ?? "-",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff1A237E),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            /// CHECK-IN ADDRESS
                            Text(
                              "📍 ${item['check_in_address'] ?? '-'}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 8),

                            /// DIVIDER
                            Container(
                              height: 1,
                              color: Colors.grey.withOpacity(0.2),
                            ),

                            const SizedBox(height: 8),

                            /// CHECK-OUT TIME
                            Row(
                              children: [
                                const Text(
                                  "Check-Out: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  item['check_out_time'] ?? "-",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            /// CHECK-OUT ADDRESS
                            Text(
                              "📍 ${item['check_out_address'] ?? '-'}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 8),

                            /// TANGGAL
                            Text(
                              item['attendance_date'] ?? "-",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// STATUS
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          item['status'] ?? "Masuk",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
