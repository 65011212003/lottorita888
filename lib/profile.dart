import 'package:flutter/material.dart';
import 'package:lottorita888/home.dart';
import 'package:lottorita888/main.dart';
import 'package:lottorita888/reward.dart';
import 'package:lottorita888/safe.dart';
import 'package:lottorita888/services/api_service.dart';
 // Add this import

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

  Map<String, dynamic> userData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final user = await ApiService.getUser(int.parse(widget.userId));
      setState(() {
        userData = user;
        _usernameController.text = user['username'] ?? '';
        _emailController.text = user['email'] ?? '';
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
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
      await ApiService.editProfile(
        int.parse(widget.userId),
        _usernameController.text,
        _passwordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('อัปเดตโปรไฟล์สำเร็จ')),
      );
      fetchUserData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่สามารถอัปเดตโปรไฟล์: $e')),
      );
    }
  }

  void _logout(BuildContext context) async {
    // Perform any logout actions here, such as clearing user data or tokens
    // For example, you might want to clear shared preferences or local storage

    // Navigate to the LoginScreen and remove all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
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
                  child: SingleChildScrollView(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildProfileCard(),
                  ),
                ),
                _buildBottomNavBar(context),
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
          Text(
            '${userData['wallet'] ?? 0}',
            style: const TextStyle(color: Colors.white, fontSize: 18),
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
          _buildTextField('รหัสผ่าน', _passwordController, obscureText: true),
          _buildTextField('ยืนยันรหัสผ่าน', _confirmPasswordController, obscureText: true),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _editProfile,
                  style: ElevatedButton.styleFrom(foregroundColor: Colors.black, backgroundColor: Colors.grey[300]),
                  child: const Text('แก้ไข'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Implement deposit functionality
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  child: const Text('ฝากเงิน'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _logout(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('ออกจากระบบ'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      color: Colors.amber,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, Icons.calendar_today, 'หวย', () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage(userId: widget.userId)),
            );
          }),
          _buildNavItem(context, Icons.emoji_events, 'รางวัล', () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RewardPage()),
            );
          }),
          _buildNavItem(context, Icons.person, 'บัญชี', () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SafePage()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, VoidCallback onTap) {
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