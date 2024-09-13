import 'package:flutter/material.dart';
import 'package:lottorita888/admin_home.dart';
import 'package:lottorita888/home.dart';
import 'dart:ui';
import 'register.dart';
import 'package:lottorita888/services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOTTORITA 69',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (result.containsKey('user_id') && result.containsKey('role')) {
        String userId = result['user_id'].toString();
        String role = result['role'].toString();

        if (role == 'admin') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LotteryAdminPage()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage(userId: userId)),
          );
        }
      } else {
        throw Exception('User ID or role not found in the response');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เข้าสู่ระบบล้มเหลว: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'LOTTORITA 69',
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                      fontFamily: 'Abel',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'ชุดใหญ่ โอนไว จัดเต็ม พร้อมบิด',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 247, 247, 247),
                      fontFamily: 'Kanit',
                    ),
                  ),
                  const SizedBox(height: 30),
                  Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0), // มุมบนซ้ายไม่เป็นมุมกลม
                        topRight:
                            Radius.circular(16), // มุมบนขวายังคงเป็นมุมกลม
                        bottomLeft:
                            Radius.circular(16), // มุมล่างซ้ายยังคงเป็นมุมกลม
                        bottomRight:
                            Radius.circular(0), // มุมล่างขวาไม่เป็นมุมกลม
                      ),
                    ),
                    color: Colors.white.withOpacity(0.8),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'เข้าสู่ระบบ',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontFamily: 'Kanit',
                            ),
                          ),
                          const SizedBox(height: 20),
                          Transform.translate(
                            offset:
                                const Offset(25.0, 0.0), // ขยับไปทางขวา 8 หน่วย
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'อีเมล',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white,
                            ),
                            child: TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                border: InputBorder.none, // ลบขอบใน TextField
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 10.0), // Padding ภายในกล่อง
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Transform.translate(
                            offset:
                                const Offset(25.0, 0.0), // ขยับไปทางขวา 8 หน่วย
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'รหัสผ่าน',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white,
                            ),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none, // ลบขอบใน TextField
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 10.0), // Padding ภายในกล่อง
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                              keyboardType: TextInputType.visiblePassword,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFE0AA3E), // สีจากขอบซ้าย
                                  Color(0xFFF7EF8A), // สีตรงกลาง
                                  Color(0xFFE0AA3E), // สีขอบขวา
                                ],
                                stops: [0.0, 0.5, 1.0], // ไล่สีจากซ้าย กลาง ขวา
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),

                              borderRadius: BorderRadius.circular(
                                  8.0), // ให้ขอบมนเล็กน้อย
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .transparent, // ทำให้ background โปร่งใสเพื่อให้เห็น gradient
                                shadowColor: Colors.transparent, // ลบเงาออก
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.black)
                                  : const Text(
                                      'เข้าสู่ระบบ',
                                      style: TextStyle(
                                        fontFamily: 'Kanit',
                                        color: Colors.black, // สีตัวอักษร
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 30),
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
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.white), // พื้นหลังสีขาว

                                  padding: WidgetStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 20.0), // ระยะ padding
                                  ),
                                  minimumSize: WidgetStateProperty.all<Size>(
                                      const Size(100, 40)), // ขนาดขั้นต่ำ
                                ),
                                child: const Text(
                                  'สมัครสมาชิก',
                                  style: TextStyle(
                                    fontFamily: 'Kanit',
                                    color: Colors.black, // สีข้อความเป็นสีดำ
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ),
                                  );
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
