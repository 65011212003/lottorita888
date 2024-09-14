import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottorita888/home.dart';
import 'package:lottorita888/main.dart';
import 'package:lottorita888/reward.dart';
import 'package:lottorita888/safe.dart';
import 'package:lottorita888/services/api_service.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _depositAmountController = TextEditingController();

  Map<String, dynamic> userData = {};
  bool isLoading = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final user = await ApiService.getUser(int.parse(widget.userId));
      setState(() {
        userData = user;
        _usernameController.text = user['username'] ?? '';
        _emailController.text = user['email'] ?? '';
        _passwordController.text = user['password'] ?? '';
        _confirmPasswordController.text = user['password'] ?? '';
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่สามารถดึงข้อมูลผู้ใช้: $e')),
      );
    }
  }

  Future<void> _editProfile() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('รหัสผ่านไม่ตรงกัน')),
      );
      return;
    }

    try {
      final result = await ApiService.editProfile(
        int.parse(widget.userId),
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('อัปเดตโปรไฟล์สำเร็จ: ${result['message'] ?? ''}')),
      );
      fetchUserData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่สามารถอัปเดตโปรไฟล์: $e')),
      );
    }
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  void _showDepositDialog() {
    int currentWallet = (userData['wallet'] as num?)?.toInt() ?? 0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            int depositAmount = int.tryParse(_depositAmountController.text) ?? 0;
            int newBalance = currentWallet + depositAmount;
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              content: Container(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('ฝากไว ภายใน 0.1 วิ', style: TextStyle(fontWeight: FontWeight.bold)),
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(Icons.close, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              children: [
                                const Text('\$', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _depositAmountController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('credit'),
                              Text('$currentWallet-'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('ฝาก'),
                              Text('+ $depositAmount-'),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('ยอดคงเหลือ'),
                              Text('$newBalance-'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        try {
                          final result = await ApiService.deposit(
                            int.parse(widget.userId),
                            depositAmount.toDouble(),
                          );
                          setState(() {
                            userData['wallet'] = result['new_balance'];
                          });
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('ฝากเงินสำเร็จ: ${result['message']}')),
                          );
                          fetchUserData(); // Refresh user data after deposit
                        } catch (e) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('ไม่สามารถฝากเงิน: $e')),
                          );
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                        ),
                        child: const Text(
                          'ฝาก',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: _buildProfileCard(),
                        ),
                ),
                _buildBottomNavBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              userData['username']?.substring(0, 1).toUpperCase() ?? 'U',
              style: const TextStyle(color: Colors.black),
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet,
                color: Color.fromARGB(255, 246, 246, 246),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${(userData['wallet'] as num?)?.toInt() ?? 0}',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.purple[100],
            child: const Icon(Icons.person_outline, size: 50, color: Colors.purple),
          ),
          const SizedBox(height: 16),
          const Text(
            'แก้ไขสมาชิก',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildTextField('ชื่อผู้ใช้', _usernameController),
          _buildTextField('อีเมล', _emailController),
          _buildPasswordField('รหัสผ่าน', _passwordController, _obscurePassword, () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          }),
          _buildPasswordField('ยืนยันรหัสผ่าน', _confirmPasswordController, _obscureConfirmPassword, () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          }),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _editProfile,
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.grey[300]),
                  child: const Text('แก้ไข'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _showDepositDialog,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 240, 217, 150)),
                  child: const Text('ฝากเงิน'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _logout,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('ออกจากระบบ'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool obscureText, VoidCallback onToggle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 10.0,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: onToggle,
            ),
          ),
          keyboardType: TextInputType.visiblePassword,
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF7EF8A),
            Color(0xFFE0AA3E),
            Color(0xFFF7EF8A),
            Color(0xFFE0AA3E),
          ],
          stops: [0.0, 0.5, 1.5, 2.5],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.calendar_today, 'หวย', () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage(userId: widget.userId)),
            );
          }),
          _buildNavItem(Icons.emoji_events, 'รางวัล', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RewardPage(userId: widget.userId)),
            );
          }),
          _buildNavItem(Icons.account_balance_wallet, 'ตู้เซฟ', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SafePage(userId: widget.userId)),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          Text(label),
        ],
      ),
    );
  }
}