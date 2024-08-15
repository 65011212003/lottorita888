import 'package:flutter/material.dart';

class SafePage extends StatefulWidget {
  const SafePage({super.key});

  @override
  _SafePageState createState() => _SafePageState();
}

class _SafePageState extends State<SafePage> {
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
                _buildTitle(),
                _buildDateDisplay(),
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildLotteryList(),
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
    return const Padding(
      padding: EdgeInsets.all(16.0),
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
          Text('400', style: TextStyle(color: Colors.white, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        'ดูโพย',
        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDateDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: Colors.black.withOpacity(0.5),
      child: const Text(
        'งวดวันที่ 16 สิงหาคม 2567',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _buildLotteryList() {
    return Column(
      children: [
        _buildLotteryItem('1 1 1 1 1 1', 'ยินดีด้วย ถูกทุก รางวัลที่ 1', true),
        _buildLotteryItem('5 6 3 2 1 2', 'เสียใจด้วย คุณถูกใบ้หวยจ้า', false),
        _buildLotteryItem('3 4 2 6 7 8', 'เสียใจด้วย คุณถูกใบ้หวยจ้า', false),
        _buildLotteryItem('6 9 2 1 8 4', 'ยินดีด้วย ถูกทุก รางวัลที่ 2', true),
        _buildLotteryItem('5 5 5 3 2 1', 'เสียใจด้วย คุณถูกใบ้หวยจ้า', false),
      ],
    );
  }

  Widget _buildLotteryItem(String numbers, String message, bool isWinner) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    numbers,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.brown[300],
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 50,
            height: double.infinity,
            color: isWinner ? Colors.green : Colors.red,
            child: Icon(
              isWinner ? Icons.check : Icons.close,
              color: Colors.white,
            ),
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
            _buildNavItem(Icons.person, 'ดูโพย', isSelected: true),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isSelected = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isSelected ? Colors.white : Colors.black),
        Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
      ],
    );
  }
}