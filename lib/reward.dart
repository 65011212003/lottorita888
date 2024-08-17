import 'package:flutter/material.dart';
import 'package:lottorita888/home.dart';
import '../services/api_service.dart';
import 'package:lottorita888/safe.dart';

class RewardPage extends StatefulWidget {
  const RewardPage({Key? key}) : super(key: key);
  
  get userId => null;

  @override
  _RewardPageState createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  List<Map<String, dynamic>> _lotteryResults = [];
  bool _isLoading = true;
  String _username = 'joe';
  int _wallet = 400;

  @override
  void initState() {
    super.initState();
    _fetchLotteryResults();
  }

  Future<void> _fetchLotteryResults() async {
    try {
      final results = await ApiService.drawLottery();
      setState(() {
        _lotteryResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch lottery results: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: _buildRewardsList(),
                      ),
              ),
              _buildBottomNavBar(context),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(_username[0].toUpperCase(), style: const TextStyle(color: Colors.black)),
              ),
              const SizedBox(width: 8),
              Text(_username, style: const TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.account_balance_wallet, color: Colors.black, size: 20),
                const SizedBox(width: 4),
                Text('$_wallet', style: const TextStyle(color: Colors.black, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateDisplay() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        'งวดวันที่ 16 สิงหาคม 2567',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _buildRewardsList() {
    if (_lotteryResults.isEmpty) {
      return const Center(child: Text('No lottery results available.', style: TextStyle(color: Colors.white)));
    }

    return Column(
      children: [
        _buildRewardCard('รางวัลที่ 1', '1 1 1 1 1 1', 'รางวัล 1,000,000 บาท'),
        _buildRewardCard('รางวัลที่ 2', '6 8 2 1 8 4', 'รางวัล 200,000 บาท'),
        _buildRewardCard('รางวัลที่ 3', '5 4 3 1 9 0', 'รางวัล 80,000 บาท'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSmallRewardCard('รางวัลที่ 4', '5 3 2 3 4 6', 'รางวัล 40,000 บาท'),
            SizedBox(width: 10),
            _buildSmallRewardCard('รางวัลที่ 5', '9 0 2 1 2 4', 'รางวัล 20,000 บาท'),
          ],
        ),
      ],
    );
  }

  Widget _buildRewardCard(String title, String numbers, String prize) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
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

  Widget _buildSmallRewardCard(String title, String numbers, String prize) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.43,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
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

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      color: Color(0xFFFFA500),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, Icons.home, 'หวย', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage(userId: widget.userId)),
            );
          }),
          _buildNavItem(context, Icons.emoji_events, 'รางวัล', () {
            // Already on rewards page
          }),
          _buildNavItem(context, Icons.person, 'ดูโพย', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SafePage(userId: widget.userId)),
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
          Icon(icon, color: Colors.black),
          Text(label, style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}