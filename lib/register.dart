import 'package:flutter/material.dart';
import 'dart:ui';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _walletController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _walletController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('รหัสผ่านไม่ตรงกัน')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Fetch all users
        List<Map<String, dynamic>> allUsers = await ApiService.getAllUsers();

        // Check if email already exists
        bool emailExists = allUsers.any((user) => user['email'] == _emailController.text);

        if (emailExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('อีเมลนี้ถูกใช้งานแล้ว กรุณาใช้อีเมลอื่น')),
          );
        } else {
          final result = await ApiService.register(
            _usernameController.text,
            _emailController.text,
            _passwordController.text,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('สมัครสมาชิกสำเร็จ')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('สมัครสมาชิกไม่สำเร็จ: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Text(
                          'LOTTORITA 69',
                          style: TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontFamily: 'Abel',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          'ชุดใหญ่ โอนไว จัดเต็ม พร้อมบิด',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'Kanit',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const Text(
                                'สมัครสมาชิก',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black87,
                                  fontFamily: 'Kanit',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              _buildTextField('ชื่อผู้ใช้', _usernameController),
                              const SizedBox(height: 10),
                              _buildTextField('อีเมล', _emailController, keyboardType: TextInputType.emailAddress),
                              const SizedBox(height: 10),
                              _buildTextField('รหัสผ่าน', _passwordController, isPassword: true, obscureText: _obscurePassword, onToggleVisibility: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              }),
                              const SizedBox(height: 10),
                              _buildTextField('ยืนยันรหัสผ่าน', _confirmPasswordController, isPassword: true, obscureText: _obscureConfirmPassword, onToggleVisibility: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              }),
                              const SizedBox(height: 20),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFE0AA3E),
                                      Color(0xFFF7EF8A),
                                      Color(0xFFE0AA3E),
                                    ],
                                    stops: [0.0, 0.5, 1.0],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _register,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                  child: _isLoading
                                      ? const CircularProgressIndicator()
                                      : const Text(
                                          'สมัคร',
                                          style: TextStyle(
                                            fontFamily: 'Kanit',
                                            color: Colors.black,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextButton(
                                child: Text(
                                  'กลับสู่หน้าเข้าสู่ระบบ',
                                  style: TextStyle(color: Colors.blue[700]),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hintText,
    TextEditingController controller, {
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: const Offset(25.0, 0.0),
          child: Text(
            hintText,
            style: const TextStyle(
              fontSize: 15.0,
              color: Colors.black,
              fontFamily: 'Kanit',
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword ? obscureText : false,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 10.0,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: onToggleVisibility,
                    )
                  : null,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณากรอก$hintText';
              }
              if (hintText == 'อีเมล' && !_isValidEmail(value)) {
                return 'กรุณากรอกอีเมลที่ถูกต้อง';
              }
              if (hintText == 'ยืนยันรหัสผ่าน' && value != _passwordController.text) {
                return 'รหัสผ่านไม่ตรงกัน';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}