import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEDEDF2),

      /// APPBAR
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
        centerTitle: false,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            /// TITLE
            const Text(
              "Create Account",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xff1A237E),
              ),
            ),

            const SizedBox(height: 30),

            /// FULL NAME
            const Text("FULL NAME", style: TextStyle(fontSize: 12)),
            const SizedBox(height: 8),

            TextField(
              controller: name,
              decoration: InputDecoration(
                hintText: "Enter your full name",
                filled: true,
                fillColor: const Color(0xffF3F3F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// EMAIL
            const Text("EMAIL", style: TextStyle(fontSize: 12)),
            const SizedBox(height: 8),

            TextField(
              controller: email,
              decoration: InputDecoration(
                hintText: "@",
                prefixIcon: const Icon(Icons.email),
                filled: true,
                fillColor: const Color(0xffF3F3F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// PASSWORD
            const Text("PASSWORD", style: TextStyle(fontSize: 12)),
            const SizedBox(height: 8),

            TextField(
              controller: password,
              obscureText: isHiddenPass,
              decoration: InputDecoration(
                hintText: "********",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    isHiddenPass ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isHiddenPass = !isHiddenPass;
                    });
                  },
                ),
                filled: true,
                fillColor: const Color(0xffF3F3F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// CONFIRM PASSWORD
            const Text("CONFIRM PASSWORD", style: TextStyle(fontSize: 12)),
            const SizedBox(height: 8),

            TextField(
              controller: confirmPassword,
              obscureText: isHiddenConfirm,
              decoration: InputDecoration(
                hintText: "********",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    isHiddenConfirm ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isHiddenConfirm = !isHiddenConfirm;
                    });
                  },
                ),
                filled: true,
                fillColor: const Color(0xffF3F3F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// BUTTON REGISTER
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1A237E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("REGISTER", style: TextStyle(fontSize: 16)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
