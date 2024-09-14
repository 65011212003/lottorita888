import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottorita888/home.dart';
import 'package:lottorita888/profile.dart';
import 'package:lottorita888/reward.dart';
import 'package:lottorita888/safe.dart';
import 'package:lottorita888/services/api_service.dart';

class SearchPage extends StatefulWidget {
  final String userId;
  const SearchPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Map<String, dynamic> userData = {};
  List<Map<String, dynamic>> lotteries = [];
  bool isLoadingMore = false;
  List<TextEditingController> numberControllers =
      List.generate(6, (_) => TextEditingController());
  String selectedCategory = 'ทั้งหมด';

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchLotteries();
  }

  @override
  void dispose() {
    for (var controller in numberControllers) {
      controller.dispose();
    }
    super.dispose();
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
          child: ListView(
            children: [
              _buildAppBar(),
              _buildTitle(),
              _buildSearchCard(),
              _buildLotteryNumber(),
              _buildLoadingIndicator(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
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

  Future<void> fetchLotteries() async {
    try {
      final fetchedLotteries = await ApiService.getLotteries(filter: '');
      setState(() {
        lotteries = fetchedLotteries;
      });
    } catch (e) {
      print('Error fetching lotteries: $e');
    }
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
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet,
                    color: Color.fromARGB(255, 255, 255, 255), size: 20),
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
                  color: Colors.white, fontSize: 40, fontFamily: 'Abel')),
          Text('ชุดใหญ่ โอนไว จัดเต็ม พร้อมบิด',
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontFamily: 'Kanit')),
        ],
      ),
    );
  }

  Widget _buildSearchCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ค้นหาเลขเด็ด!',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                    fontFamily: 'Kanit')),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _clearSearch,
                  child: const Text('ล้างค่า',
                      style: TextStyle(color: Colors.red, fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) => _buildNumberBox(index)),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 53,
                    child: ElevatedButton(
                      onPressed: _randomizeNumbers,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0), // มุมโค้ง
                        ),
                        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('สุ่มตัวเลข',
                          style: TextStyle(
                              color: Color.fromARGB(255, 248, 248, 248),
                              fontSize: 16)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _searchLotteries,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0), // มุมโค้ง
                        ),
                        backgroundColor:
                            Colors.transparent, // ตั้งค่าให้โปร่งใส
                        shadowColor:
                            Colors.transparent, // ลบเงาของ ElevatedButton
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFAE8625), // สี AE8625
                              Color(0xFFF7EF8A), // สี F7EF8A
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(
                              8.0), // มุมโค้งของกราเดียนต์
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            'ค้นหา',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String text, {bool isSelected = false}) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCategory = text;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.amber : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

  Widget _buildNumberBox(int index) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: numberControllers[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildLotteryNumber() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children:
            lotteries.map((lottery) => _buildLotteryItem(lottery)).toList(),
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
                          letterSpacing: 25.0,
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kanit'),
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
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFAE8625), // สี AE8625
                            Color(0xFFF7EF8A), // สี F7EF8A
                          ],
                          begin: Alignment.topLeft, // จุดเริ่มต้นของ gradient
                          end: Alignment.bottomRight, // จุดสิ้นสุดของ gradient
                        ),
                        borderRadius: BorderRadius.circular(10), // มุมโค้ง
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              lottery['number'].toString(),
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 5.0,
                                  fontFamily: 'Abel'),
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
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Failed to purchase lottery: $e')),
                          );
                        }
                      },
                      child: const Text('ยืนยัน',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Kanit',
                          )),
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

  void updateLotteryStatus(int lotteryId) {
    setState(() {
      final index =
          lotteries.indexWhere((lottery) => lottery['id'] == lotteryId);
      if (index != -1) {
        lotteries[index]['is_sold'] = true;
      }
    });
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
          _buildNavItem(Icons.person, 'ตู้เซฟ', () {
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

  void _clearSearch() {
    setState(() {
      for (var controller in numberControllers) {
        controller.clear();
      }
      selectedCategory = 'ทั้งหมด';
    });
    fetchLotteries();
  }

  void _randomizeNumbers() {
    if (lotteries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่มีหวยในระบบ')),
      );
      return;
    }

    // Extract available lottery numbers
    List<String> availableNumbers = lotteries
        .where((lottery) => lottery['is_sold'] != true)
        .map((lottery) => lottery['number'].toString())
        .toList();

    if (availableNumbers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่มีหวยที่ยังไม่ถูกขายในระบบ')),
      );
      return;
    }

    // Randomly select a lottery number
    String selectedNumber =
        availableNumbers[Random().nextInt(availableNumbers.length)];

    setState(() {
      // Fill the number controllers with the selected number
      for (int i = 0; i < numberControllers.length; i++) {
        if (i < selectedNumber.length) {
          numberControllers[i].text = selectedNumber[i];
        } else {
          numberControllers[i].text = '';
        }
      }
    });
  }

  void _searchLotteries() async {
    String searchNumber =
        numberControllers.map((controller) => controller.text).join();

    setState(() {
      isLoadingMore = true; // Show loading indicator
    });

    try {
      final allLotteries = await ApiService.getLotteries(filter: '');
      final filteredLotteries = allLotteries.where((lottery) {
        String lotteryNumber = lottery['number'].toString();
        return lotteryNumber.contains(searchNumber);
      }).toList();

      setState(() {
        lotteries = filteredLotteries;
        isLoadingMore = false; // Hide loading indicator
      });

      if (filteredLotteries.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไม่พบหวยที่ตรงกับการค้นหา')),
        );
      }
    } catch (e) {
      print('Error searching lotteries: $e');
      setState(() {
        isLoadingMore = false; // Hide loading indicator
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('เกิดข้อผิดพลาดในการค้นหา กรุณาลองใหม่อีกครั้ง')),
      );
    }
  }
}
