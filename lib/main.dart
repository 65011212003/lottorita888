import 'package:flutter/material.dart';
import 'package:lottorita888/home.dart';
import 'package:lottorita888/profile.dart';
import 'package:lottorita888/reward.dart';
import 'package:lottorita888/safe.dart';
import 'package:lottorita888/search.dart';
import 'dart:ui';
import 'register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOTTORITA 69',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SafePage(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image with blur
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2), // Adjust blur intensity here
              child: Container(
                color: Colors.black.withOpacity(0.3), // This creates the 0.45 opacity effect
              ),
            ),
          ),
          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'LOTTORITA 69',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'ชุดใหญ่ โอนไว จัดเต็ม พร้อมบิด',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 247, 247, 247),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          const TextField(
                            decoration: InputDecoration(
                              labelText: 'ชื่อผู้ใช้/เบอร์โทรศัพท์',
                            ),
                          ),
                          const SizedBox(height: 10),
                          const TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'รหัสผ่าน',
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            child: const Text('เข้าสู่ระบบ'),
                            onPressed: () {
                              // Login logic here
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.amber,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              TextButton(
                                child: const Text('ลืมรหัสผ่าน'),
                                onPressed: () {
                                  // Forgot password logic
                                },
                              ),
                              TextButton(
                                child: const Text('สมัครสมาชิก'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => RegisterScreen())) ;
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
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