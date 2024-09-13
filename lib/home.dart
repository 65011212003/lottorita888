import 'package:flutter/material.dart';
import 'package:lottorita888/profile.dart';
import 'package:lottorita888/search.dart';
import 'package:lottorita888/services/api_service.dart';
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
  final int itemsPerPage = 100;
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
        filter: '',
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

  void updateLotteryStatus(int lotteryId) {
    setState(() {
      int index = lotteries.indexWhere((lottery) => lottery['id'] == lotteryId);
      if (index != -1) {
        lotteries[index]['is_sold'] = true;
      }
    });
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
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.30),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet,
                    color: Color.fromARGB(255, 246, 246, 246), size: 20),
                const SizedBox(width: 8),
                Text(
                  '${userData['wallet'] ?? 0}',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 18, fontFamily: 'Abel'),
                ),
              ],
            ),
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
                fontSize: 37,
                fontFamily: 'Abel',
              )),
          Text('ชุดใหญ่ โอนไว จัดเต็ม พร้อมมิติ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Kanit',
              )),
          Text('อันดีต ปัจจุบัน อนาคตครบ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Kanit',
              )),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'ขอโชคใบไฮโล',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Kanit',
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchPage(userId: widget.userId)),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFAE8625), // สี AE8625
                      Color(0xFFF7EF8A), // สี F7EF8A
                    ],
                    begin: Alignment.topLeft, // จุดเริ่มต้นของ gradient
                    end: Alignment.bottomRight, // จุดสิ้นสุดของ gradient
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.search, color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
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
    if (lottery['is_sold'] == true) {
      return Container(); // Return an empty container for sold lotteries
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFAE8625), // AE8625
              Color(0xFFF7EF8A), // F7EF8A
              Color(0xFFD2AC47), // D2AC47
              Color(0xFFEDC967), // EDC967
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(lottery['number'].toString(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontFamily: 'Abel',
                          color: Colors.black,
                          letterSpacing: 30.0,
                        )),
                    const Text('Price: 100',
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Abel',
                        )),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _showPurchaseConfirmationDialog(lottery);
              },
              child: Container(
                height: 87,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: const Icon(Icons.shopping_cart, color: Colors.yellow),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPurchaseConfirmationDialog(Map<String, dynamic> lottery) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ยืนยันการซื้อ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(Icons.close, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              lottery['number'].toString(),
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const Text('Lottorita 888',
                                style: TextStyle(color: Colors.black54)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Credit'),
                        Text('${userData['wallet']}.-',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('จำนวน 1'),
                        Text('-100.-', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    const Divider(thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ยอดคงเหลือ'),
                        Text('${userData['wallet'] - 100}.-',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          final result = await ApiService.buyLottery(
                              int.parse(widget.userId), lottery['id']);
                          if (result['message'] ==
                              'Lottery purchased successfully') {
                            setState(() {
                              userData['wallet'] -= 100;
                            });
                            Navigator.of(context).pop();
                            // Update the lottery status and refresh the UI
                            updateLotteryStatus(lottery['id']);
                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Lottery purchased successfully!')));
                            // Refresh user data
                            fetchUserData();
                          }
                        } catch (e) {
                          String errorMessage = 'Failed to purchase lottery';
                          if (e.toString().contains('Insufficient funds')) {
                            errorMessage =
                                'Insufficient funds to purchase lottery';
                          } else if (e
                              .toString()
                              .contains('Lottery not found')) {
                            errorMessage =
                                'This lottery is no longer available';
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(errorMessage)),
                          );
                        }
                      },
                      child:
                          const Text('ยืนยัน', style: TextStyle(fontSize: 18)),
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

  Widget _buildBottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF7EF8A), // สีเริ่มต้นที่ขอบซ้าย
            Color(0xFFE0AA3E), // สีตรงกลาง
            Color(0xFFF7EF8A),
            Color(0xFFE0AA3E), // สีที่ขอบขวา
          ],
          stops: [0.0, 0.5, 1.5, 2.5], // จุดที่สีเริ่มต้นและสิ้นสุด
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
              MaterialPageRoute(
                builder: (context) => HomePage(userId: widget.userId),
              ),
            );
          }),
          _buildNavItem(Icons.emoji_events, 'รางวัล', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RewardPage(userId: widget.userId),
              ),
            );
          }),
          _buildNavItem(Icons.person, 'บัญชี', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SafePage(userId: widget.userId),
              ),
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
