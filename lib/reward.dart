import 'package:flutter/material.dart';

class RewardPage extends StatefulWidget {
  const RewardPage({Key? key}) : super(key: key);

  @override
  _RewardPageState createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
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
                _buildDateDisplay(),
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildRewardsList(),
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
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Text('joe', style: TextStyle(color: Colors.black)),
              ),
              SizedBox(width: 8),
              Text('joe', style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
          Row(
            children: [
              Icon(Icons.account_balance_wallet, color: Colors.white),
              SizedBox(width: 4),
              Text('400', style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateDisplay() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        'งวดวันที่ 16 สิงหาคม 2567',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _buildRewardsList() {
    return Column(
      children: [
        _buildRewardCard('รางวัลที่ 1', '1 1 1 1 1 1', '1,000,000 บาท'),
        _buildRewardCard('รางวัลที่ 2', '6 8 2 1 8 4', '200,000 บาท'),
        _buildRewardCard('รางวัลที่ 3', '5 4 3 1 9 0', '80,000 บาท'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSmallRewardCard('รางวัลที่ 4', '5 3 2 3 4 6', '40,000 บาท'),
            _buildSmallRewardCard('รางวัลที่ 5', '9 0 2 1 2 4', '20,000 บาท'),
          ],
        ),
      ],
    );
  }

  Widget _buildRewardCard(String title, String numbers, String prize) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            color: Colors.amber[100],
            child: Center(
              child: Text(
                numbers,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 8),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(prize, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallRewardCard(String title, String numbers, String prize) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            color: Colors.amber[100],
            child: Center(
              child: Text(
                numbers,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 4),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(prize, style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      color: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'หวย'),
            _buildNavItem(Icons.emoji_events, 'รางวัล'),
            _buildNavItem(Icons.person, 'ดูโพย'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        Text(label),
      ],
    );
  }
}