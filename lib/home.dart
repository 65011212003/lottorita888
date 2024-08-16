import 'package:flutter/material.dart';
import 'package:lottorita888/profile.dart';
import 'package:lottorita888/search.dart';
import 'services/api_service.dart';
import 'reward.dart';
import 'safe.dart';

class HomePage extends StatefulWidget {
  final String userId;

  const HomePage({Key? key, required this.userId}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> lotteries = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  Map<String, dynamic> userData = {};
  int currentPage = 0;
  final int itemsPerPage = 20;
  bool hasMoreItems = true;

  @override
  void initState() {
    super.initState();
    fetchLotteries();
    fetchUserData();
  }

  Future<void> fetchLotteries({bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore || !hasMoreItems) return;
      setState(() {
        isLoadingMore = true;
      });
    } else {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final fetchedLotteries = await ApiService.getLotteries(
        skip: currentPage * itemsPerPage,
        limit: itemsPerPage,
      );
      setState(() {
        if (loadMore) {
          lotteries.addAll(fetchedLotteries);
          isLoadingMore = false;
        } else {
          lotteries = fetchedLotteries;
          isLoading = false;
        }
        currentPage++;
        hasMoreItems = fetchedLotteries.length == itemsPerPage;
      });
    } catch (e) {
      print('Error fetching lotteries: $e');
      setState(() {
        if (loadMore) {
          isLoadingMore = false;
        } else {
          isLoading = false;
        }
      });
    }
  }

  Future<void> fetchUserData() async {
    try {
      final user = await ApiService.getUser(int.parse(widget.userId));
      setState(() {
        userData = user;
      });
    } catch (e) {
      print('Error fetching user data: $e');
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(userId: widget.userId),
                ),
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                userData['username']?.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(color: Colors.black),
              ),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ขอโชคใบไฮโล',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
            child: const Icon(Icons.search, color: Colors.amber),
          ),
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
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            fetchLotteries(loadMore: true);
          }
          return true;
        },
        child: ListView.builder(
          itemCount: lotteries.length + (hasMoreItems ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == lotteries.length) {
              return _buildLoadingIndicator();
            }
            return _buildLotteryItem(lotteries[index]);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: isLoadingMore
            ? const CircularProgressIndicator()
            : const Text('No more items',
                style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildLotteryItem(Map<String, dynamic> lottery) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                    const Text('Price: 100',
                        style: TextStyle(color: Colors.black54)),
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
  }

  Widget _buildBottomNavBar() {
    return Container(
      color: Colors.amber,
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