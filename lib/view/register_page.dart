import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:absensi_apps/api/endpoint.dart';
import 'package:absensi_apps/view/login_page.dart';
import 'package:flutter/material.dart';
import '../api/register.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  bool isHiddenPass = true;
  bool isHiddenConfirm = true;
  bool isLoading = false;

  List batchList = [];
  List trainingList = [];

  String? selectedBatch;
  String? selectedTraining;
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    loadMasterData();
  }

  Future<void> loadMasterData() async {
    try {
      final batchRes = await http.get(Uri.parse("${Endpoint.baseUrl}/batches"));
      final trainingRes = await http.get(
        Uri.parse("${Endpoint.baseUrl}/trainings"),
      );

      final batchData = jsonDecode(batchRes.body);
      final trainingData = jsonDecode(trainingRes.body);

      setState(() {
        batchList = batchData['data'] ?? [];
        trainingList = trainingData['data'] ?? [];
      });
    } catch (e) {
      print("ERROR: $e");
    }
  }

  Future<void> handleRegister() async {
    if (name.text.isEmpty ||
        email.text.isEmpty ||
        password.text.isEmpty ||
        confirmPassword.text.isEmpty ||
        selectedBatch == null ||
        selectedTraining == null ||
        selectedGender == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Semua field wajib diisi")));
      return;
    }

    if (password.text != confirmPassword.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Password tidak sama")));
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await registerUser(
        name: name.text,
        email: email.text,
        password: password.text,
        confirmPassword: confirmPassword.text,
        batchId: selectedBatch!,
        trainingId: selectedTraining!,
        jenisKelamin: selectedGender!,
      );

      if (result != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Register berhasil")));

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEDEDF2),

      appBar: AppBar(
        backgroundColor: const Color(0xffEDEDF2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "PPKD JAKPUS",
          style: TextStyle(
            color: Color(0xff2D3A8C),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: batchList.isEmpty || trainingList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 30),

                  TextField(controller: name, decoration: _input("Nama")),

                  const SizedBox(height: 20),

                  TextField(controller: email, decoration: _input("Email")),

                  const SizedBox(height: 20),

                  /// BATCH
                  DropdownButtonFormField<String>(
                    value: selectedBatch,
                    hint: const Text("Pilih Batch"),
                    isExpanded: true,
                    items: batchList.map<DropdownMenuItem<String>>((item) {
                      return DropdownMenuItem<String>(
                        value: item['id'].toString(),
                        child: Text(
                          "Batch ${item['batch_ke'] ?? '-'}",
                        ), // 🔥 FIX
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBatch = value;
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  /// TRAINING (FIX DI SINI 🔥)
                  DropdownButtonFormField<String>(
                    value: selectedTraining,
                    hint: const Text("Pilih Jurusan"),
                    isExpanded: true,
                    items: trainingList.map<DropdownMenuItem<String>>((item) {
                      return DropdownMenuItem<String>(
                        value: item['id'].toString(),
                        child: Text(
                          item['title']?.toString() ?? "-", // 🔥 FIX
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTraining = value;
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  /// GENDER
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          title: const Text("L"),
                          value: "L",
                          groupValue: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value.toString();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          title: const Text("P"),
                          value: "P",
                          groupValue: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value.toString();
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: password,
                    obscureText: isHiddenPass,
                    decoration: _input("Password"),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: confirmPassword,
                    obscureText: isHiddenConfirm,
                    decoration: _input("Confirm Password"),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1A237E),
                        disabledBackgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "REGISTER",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  InputDecoration _input(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xffF3F3F7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
