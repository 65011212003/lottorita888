// import 'package:flutter/material.dart';

// class RewardPage extends StatefulWidget {
//   const RewardPage({super.key});

//   @override
//   _RewardPageState createState() => _RewardPageState();
// }

// class _RewardPageState extends State<RewardPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background image
//           Image.asset(
//             'assets/images/background.jpg',
//             fit: BoxFit.cover,
//             width: double.infinity,
//             height: double.infinity,
//           ),
//           SafeArea(
//             child: Column(
//               children: [
//                 _buildHeader(),
//                 _buildDateDisplay(),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: _buildRewardsList(),
//                   ),
//                 ),
//                 _buildBottomNavBar(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return const Padding(
//       padding: EdgeInsets.all(16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 backgroundColor: Colors.white,
//                 child: Text('joe', style: TextStyle(color: Colors.black)),
//               ),
//               SizedBox(width: 8),
//               Text('joe', style: TextStyle(color: Colors.white, fontSize: 18)),
//             ],
//           ),
//           Row(
//             children: [
//               Icon(Icons.account_balance_wallet, color: Colors.white),
//               SizedBox(width: 4),
//               Text('400', style: TextStyle(color: Colors.white, fontSize: 18)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDateDisplay() {
//     return const Padding(
//       padding: EdgeInsets.symmetric(vertical: 8.0),
//       child: Text(
//         'งวดวันที่ 16 สิงหาคม 2567',
//         style: TextStyle(color: Colors.white, fontSize: 18),
//       ),
//     );
//   }

//   Widget _buildRewardsList() {
//     return Column(
//       children: [
//         _buildRewardCard('รางวัลที่ 1', '1 1 1 1 1 1', '1,000,000 บาท'),
//         _buildRewardCard('รางวัลที่ 2', '6 8 2 1 8 4', '200,000 บาท'),
//         _buildRewardCard('รางวัลที่ 3', '5 4 3 1 9 0', '80,000 บาท'),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildSmallRewardCard('รางวัลที่ 4', '5 3 2 3 4 6', '40,000 บาท'),
//             _buildSmallRewardCard('รางวัลที่ 5', '9 0 2 1 2 4', '20,000 บาท'),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildRewardCard(String title, String numbers, String prize) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.amber,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             color: Colors.amber[100],
//             child: Center(
//               child: Text(
//                 numbers,
//                 style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 8),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(prize, style: const TextStyle(fontSize: 16)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSmallRewardCard(String title, String numbers, String prize) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.45,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.amber,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 12),
//             color: Colors.amber[100],
//             child: Center(
//               child: Text(
//                 numbers,
//                 style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 4),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(prize, style: const TextStyle(fontSize: 14)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomNavBar() {
//     return Container(
//       color: Colors.amber,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _buildNavItem(Icons.home, 'หวย'),
//             _buildNavItem(Icons.emoji_events, 'รางวัล'),
//             _buildNavItem(Icons.person, 'ดูโพย'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem(IconData icon, String label) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon),
//         Text(label),
//       ],
//     );
//   }
// }





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
  String _username = 'joe'; // Replace with actual username
  int _wallet = 400; // Replace with actual wallet amount

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
                child: Text(_username[0].toUpperCase(), style: const TextStyle(color: Colors.black)),
              ),
              const SizedBox(width: 8),
              Text(_username, style: const TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.account_balance_wallet, color: Colors.white),
              const SizedBox(width: 4),
              Text('$_wallet', style: const TextStyle(color: Colors.white, fontSize: 18)),
            ],
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
      children: _lotteryResults.map((result) {
        return _buildRewardCard(
          'รางวัลที่ ${result['prize_tier']}',
          result['winning_number'].toString(),
          '${result['prize_amount']} บาท',
        );
      }).toList(),
    );
  }

  Widget _buildRewardCard(String title, String numbers, String prize) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Colors.amber[100],
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

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      color: Colors.amber,
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RewardPage()),
            );
          }),
          _buildNavItem(context, Icons.person, 'บัญชี', () {
            Navigator.push(
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
