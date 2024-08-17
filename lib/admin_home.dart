import 'package:flutter/material.dart';

class LotteryAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildDateDisplay(),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildRewardsList(context),
                ),
              ),
              _buildBottomNavBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.purple[100],
            child: const Text('A', style: TextStyle(color: Colors.black)),
          ),
          const SizedBox(width: 8),
          const Text('Admid', style: TextStyle(color: Colors.white, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildDateDisplay() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        'งวดวันที่ 16 สิงหาคม 2567',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildRewardsList(BuildContext context) {
    return Column(
      children: [
        _buildRewardCard('รางวัลที่ 1', 'X X X X X X', 'รางวัล 1,000,000 บาท'),
        _buildRewardCard('รางวัลที่ 2', 'X X X X X X', 'รางวัล 200,000 บาท'),
        _buildRewardCard('รางวัลที่ 3', 'X X X X X X', 'รางวัล 80,000 บาท'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSmallRewardCard(context, 'รางวัลที่ 4', 'X X X X X X', 'รางวัล 40,000 บาท'),
            const SizedBox(width: 10),
            _buildSmallRewardCard(context, 'รางวัลที่ 5', 'X X X X X X', 'รางวัล 20,000 บาท'),
          ],
        ),
        const SizedBox(height: 16),
        _buildRandomButton(),
      ],
    );
  }

  Widget _buildRewardCard(String title, String numbers, String prize) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Colors.white,
            child: Center(
              child: Text(
                numbers,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 8),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(prize, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallRewardCard(BuildContext context, String title, String numbers, String prize) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.43,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.white,
            child: Center(
              child: Text(
                numbers,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 4),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(prize, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildRandomButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.refresh, color: Colors.black),
      label: const Text('สุ่มรางวัล', style: TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFA500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

Widget _buildBottomNavBar() {
    return Container(
      color: Colors.amber,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events, color: Colors.black),
                Text('รางวัล', style: TextStyle(color: Colors.black)),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.grid_4x4, color: Colors.black),
                Text('ระบบ', style: TextStyle(color: Colors.black)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}