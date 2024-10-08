import 'package:flutter/material.dart';
import 'package:lottorita888/admin_system.dart';
import 'package:lottorita888/main.dart';
import 'package:lottorita888/services/api_service.dart';

class LotteryAdminPage extends StatefulWidget {
  const LotteryAdminPage({Key? key}) : super(key: key);

  @override
  _LotteryAdminPageState createState() => _LotteryAdminPageState();
}

class _LotteryAdminPageState extends State<LotteryAdminPage> {
  Map<String, dynamic>? _latestDraw;
  List<Map<String, dynamic>> _allDrawsInfo = [];
  bool _isLoading = false;
  bool _showAllDraws = false;

  @override
  void initState() {
    super.initState();
    _fetchAllDrawsInfo();
  }

  Future<void> _fetchAllDrawsInfo() async {
    setState(() => _isLoading = true);

    try {
      final allDrawsInfo = await ApiService.getAllDrawsInfo();
      setState(() {
        _allDrawsInfo = allDrawsInfo;
        _latestDraw = allDrawsInfo.isNotEmpty ? allDrawsInfo.first : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog(
          'ไม่สามารถดึงข้อมูลการออกรางวัลทั้งหมดได้: ${e.toString()}');
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
              _buildHeader(),
              _buildToggleButton(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchAllDrawsInfo,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: _showAllDraws
                        ? _buildAllDrawsInfo()
                        : _buildRewardsList(),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.purple[100],
                child: const Text('A', style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(width: 8),
              const Text('Admin',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
          ElevatedButton(
            onPressed: _logout,
            child: const Text('ออกจากระบบ'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _logout() {
    // Implement logout logic here
    // Clear user session (if any)
    // Navigate to LoginScreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Widget _buildToggleButton() {
    return ElevatedButton(
      onPressed: () => setState(() => _showAllDraws = !_showAllDraws),
      child: Text(_showAllDraws ? 'แสดงงวดปัจจุบัน' : 'แสดงทุกงวด'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),
    );
  }

  Widget _buildAllDrawsInfo() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_allDrawsInfo.isEmpty) {
      return const Center(
          child: Text('ยังไม่มีข้อมูลการออกรางวัล',
              style: TextStyle(color: Colors.white)));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _allDrawsInfo.length,
      itemBuilder: (context, index) => _buildDrawInfo(_allDrawsInfo[index]),
    );
  }

  Widget _buildDrawInfo(Map<String, dynamic> draw) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ExpansionTile(
        title: Text('งวดวันที่ ${draw['draw_date'] ?? 'ไม่ระบุ'}'),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: draw['winning_tickets']?.length ?? 0,
            itemBuilder: (context, index) {
              final ticket = draw['winning_tickets'][index];
              return ListTile(
                title: Text('เลขที่ถูกรางวัล: ${ticket['number']}'),
                subtitle: Text(
                    'รางวัลที่ ${ticket['prize_tier']}: ${ticket['prize_amount']} บาท'),
                trailing: Text(
                    ticket['is_claimed'] ? 'รับรางวัลแล้ว' : 'ยังไม่รับรางวัล'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsList() {
    return Column(
      children: [
        _buildDateDisplay(),
        _buildRewardCard(
            'รางวัลที่ 1', _getWinnerNumber(0), 'รางวัล 1,000,000 บาท'),
        _buildRewardCard(
            'รางวัลที่ 2', _getWinnerNumber(1), 'รางวัล 50,000 บาท'),
        _buildRewardCard(
            'รางวัลที่ 3', _getWinnerNumber(2), 'รางวัล 25,000 บาท'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSmallRewardCard(
                'รางวัลที่ 4', _getWinnerNumber(3), 'รางวัล 5,000 บาท'),
            const SizedBox(width: 10),
            _buildSmallRewardCard(
                'รางวัลที่ 5', _getWinnerNumber(4), 'รางวัล 1,000 บาท'),
          ],
        ),
        const SizedBox(height: 16),
        _buildRandomButton(),
      ],
    );
  }

  Widget _buildDateDisplay() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        _latestDraw != null
            ? 'งวดวันที่ ${_latestDraw!['draw_date']}'
            : 'ยังไม่มีการออกรางวัล',
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  String _getWinnerNumber(int index) {
    if (_latestDraw == null || _latestDraw!['winning_tickets'] == null) {
      return 'X X X X X X';
    }
    final winningTickets = _latestDraw!['winning_tickets'] as List<dynamic>;
    return (winningTickets.length > index &&
            winningTickets[index]['number'] != null)
        ? winningTickets[index]['number']
        : 'X X X X X X';
  }

  Widget _buildRewardCard(String title, String numbers, String prize) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFAE8625), // สีที่ 1
            Color(0xFFF7EF8A), // สีที่ 2
            Color(0xFFD2AC47), // สีที่ 3
            Color(0xFFEDC967), // สีที่ 4
          ],
          stops: [0.0, 0.33, 0.67, 1.0], // จุดที่สีเริ่มต้นและสิ้นสุด
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Kanit')),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFAE8625), // สีที่ 1
                  Color(0xFFF7EF8A), // สีที่ 2
                  Color(0xFFD2AC47), // สีที่ 3
                  Color(0xFFEDC967), // สีที่ 4
                ],
                stops: [0.0, 0.33, 0.67, 1.0], // จุดที่สีเริ่มต้นและสิ้นสุด
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                numbers,
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              width: 1000,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6), // สีดำพร้อมความโปร่งแสง
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10), // มุมล่างซ้ายโค้ง 10 พิกเซล
                  bottomRight: Radius.circular(10), // มุมล่างขวาโค้ง 10 พิกเซล
                ),
              ),
              child: Center(
                // ใช้ Center widget เพื่อจัดตำแหน่งข้อความตรงกลาง
                child: Text(
                  prize,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Kanit',
                    color: Colors.white, // สีข้อความ
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSmallRewardCard(String title, String numbers, String prize) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.43,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFAE8625), // สีที่ 1
            Color(0xFFF7EF8A), // สีที่ 2
            Color(0xFFD2AC47), // สีที่ 3
            Color(0xFFEDC967), // สีที่ 4
          ],
          stops: [0.0, 0.33, 0.67, 1.0], // จุดที่สีเริ่มต้นและสิ้นสุด
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Kanit')),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFAE8625), // สีที่ 1
                  Color(0xFFF7EF8A), // สีที่ 2
                  Color(0xFFD2AC47), // สีที่ 3
                  Color(0xFFEDC967), // สีที่ 4
                ],
                stops: [0.0, 0.33, 0.67, 1.0], // จุดที่สีเริ่มต้นและสิ้นสุด
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                numbers,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              width: 200,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6), // สีดำพร้อมความโปร่งแสง
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10), // มุมล่างซ้ายโค้ง 10 พิกเซล
                  bottomRight: Radius.circular(10), // มุมล่างขวาโค้ง 10 พิกเซล
                ),
              ),
              child: Center(
                // ใช้ Center widget เพื่อจัดตำแหน่งข้อความตรงกลาง
                child: Text(
                  prize,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Kanit',
                    color: Colors.white, // สีข้อความ
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRandomButton() {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _drawLottery,
      icon: _isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            )
          : const Icon(Icons.refresh, color: Colors.black),
      label: Text(_isLoading ? 'กำลังสุ่ม...' : 'สุ่มรางวัล',
          style: const TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFA500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
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
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavBarItem(Icons.emoji_events, 'รางวัล', () {}),
              _buildNavBarItem(Icons.grid_4x4, 'ระบบ', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SystemAdminPage()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, String label, VoidCallback onTap) {
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

  Future<void> _drawLottery() async {
  setState(() => _isLoading = true);

  try {
    final newDraw = await ApiService.drawLottery();
    setState(() {
      _latestDraw = newDraw as Map<String, dynamic>?;
      _allDrawsInfo.insert(0, newDraw as Map<String, dynamic>);
      _isLoading = false;
    });
  } catch (e) {
    String errorMessage = 'สุ่มรางวัลได้สำเร็จ';
    if (e is Exception) {
      errorMessage += ': ${e.toString()}';
    }
    _showErrorDialog(errorMessage);
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

void _showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        title: const Text(
          'สุ่มสำเร็จ',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontFamily: 'Kanit',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFE0AA3E),
                  Color(0xFFF7EF8A),
                  Color(0xFFE0AA3E),
                ],
                stops: [0.0, 0.5, 1.0],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextButton(
              child: const Text(
                'ตกลง',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    },
  );
}
}
