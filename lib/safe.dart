import 'package:flutter/material.dart';
import 'package:lottorita888/home.dart';
import 'package:lottorita888/reward.dart';

class SafePage extends StatefulWidget {
  final String userId;
  const SafePage({Key? key, required this.userId}) : super(key: key);

  @override
  _SafePageState createState() => _SafePageState();
}

class _SafePageState extends State<SafePage> {
  List<Map<String, dynamic>> lotteryItems = [
    {'numbers': '1 1 1 1 1 1', 'message': 'ยินดีด้วย ถูกทุก รางวัลที่ 1', 'isWinner': true},
    {'numbers': '5 6 3 2 1 2', 'message': 'เสียใจด้วย คุณถูกใบ้หวยจ้า', 'isWinner': false},
    {'numbers': '3 4 2 6 7 8', 'message': 'เสียใจด้วย คุณถูกใบ้หวยจ้า', 'isWinner': false},
    {'numbers': '6 9 2 1 8 4', 'message': 'ยินดีด้วย ถูกทุก รางวัลที่ 2', 'isWinner': true},
    {'numbers': '5 5 5 3 2 1', 'message': 'เสียใจด้วย คุณถูกใบ้หวยจ้า', 'isWinner': false},
  ];

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
                _buildTitle(),
                _buildDateDisplay(),
                Expanded(
                  child: _buildLotteryList(),
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
          const Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Text('J', style: TextStyle(color: Colors.black)),
              ),
              SizedBox(width: 8),
              Text('joe', style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.account_balance_wallet, color: Colors.black, size: 20),
                SizedBox(width: 4),
                Text('400', style: TextStyle(color: Colors.black, fontSize: 16)),
              ],
            ),
          ),
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
    return ListView.builder(
      itemCount: lotteryItems.length,
      itemBuilder: (context, index) {
        final item = lotteryItems[index];
        return _buildLotteryItem(item['numbers'], item['message'], item['isWinner'], index);
      },
    );
  }

  Widget _buildLotteryItem(String numbers, String message, bool isWinner, int index) {
    return GestureDetector(
      onTap: () {
        if (isWinner) {
          _showWinningDialog(context, numbers);
        } else {
          setState(() {
            lotteryItems.removeAt(index);
          });
        }
      },
      child: Container(
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
              height: 80,
              color: isWinner ? Colors.green : Colors.red,
              child: Icon(
                isWinner ? Icons.check : Icons.close,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWinningDialog(BuildContext context, String winningNumbers) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ชิ้นรางวัล',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    winningNumbers,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Lotteria 888', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Credit', style: TextStyle(color: Colors.grey)),
                        Text('อันดับ 1', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text('+1,000,000', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Divider(),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ยอดคงเหลือ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('1,000,400.-', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text('ยืนยัน'),
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      color: Colors.amber,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'หวย', () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage(userId: widget.userId)),
            );
          }),
          _buildNavItem(Icons.emoji_events, 'รางวัล', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RewardPage()),
            );
          }),
          _buildNavItem(Icons.person, 'บัญชี', () {
            // Already on SafePage, no navigation needed
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
          Icon(icon, color: Colors.black),
          Text(label, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}