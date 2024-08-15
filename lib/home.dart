import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'reward.dart';
import 'safe.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> lotteries = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLotteries();
  }

  Future<void> fetchLotteries() async {
    try {
      final fetchedLotteries = await ApiService.getLotteries();
      setState(() {
        lotteries = fetchedLotteries;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching lotteries: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

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
              _buildAppBar(),
              _buildTitle(),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _buildSearchBar(),
                      _buildLotteryList(),
                    ],
                  ),
                ),
              ),
              _buildBottomNavBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Text('joe', style: TextStyle(color: Colors.black)),
          ),
          Text('400', style: TextStyle(color: Colors.white, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        children: [
          Text('LOTTORITA 69',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
          Text('ชุดใหญ่ โอนไว จัดเต็ม พร้อมมิติ',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          Text('อันดีต ปัจจุบัน อนาคตครบ',
              style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ขอโชคใบไฮโล',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Icon(Icons.search, color: Colors.amber),
        ],
      ),
    );
  }

  Widget _buildLotteryList() {
    if (isLoading) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (lotteries.isEmpty) {
      return const Expanded(
        child: Center(
            child: Text('No lotteries available',
                style: TextStyle(color: Colors.white))),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: lotteries.length,
        itemBuilder: (context, index) {
          final lottery = lotteries[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lottery['number'].toString(),
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          // ignore: prefer_const_constructors
                          Text('Price: 100',
                              style: const TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black,
                    padding: const EdgeInsets.all(16),
                    child: const Icon(Icons.shopping_cart, color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

Widget _buildBottomNavBar() {
  return Container(
    color: Colors.amber,
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNavItem(Icons.calendar_today, 'หวย', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }),
        _buildNavItem(Icons.emoji_events, 'รางวัล', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RewardPage()),
          );
        }),
        _buildNavItem(Icons.person, 'บัญชี', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SafePage()),
          );
        }),
      ],
    ),
  );
}

Widget _buildNavItem(IconData icon, String label, VoidCallback? onTap) {
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
