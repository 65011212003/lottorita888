import 'package:flutter/material.dart';
import 'package:lottorita888/admin_home.dart';
import 'package:lottorita888/services/api_service.dart';

class SystemAdminPage extends StatefulWidget {
  @override
  _SystemAdminPageState createState() => _SystemAdminPageState();
}

class _SystemAdminPageState extends State<SystemAdminPage> {
  int totalLotteries = 0;
  bool isLoading = false;
  List<Map<String, dynamic>> lotteries = [];
  String currentFilter = 'all'; // 'all', 'sold', or 'unsold'

  @override
  void initState() {
    super.initState();
    fetchLotteries();
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
              _buildWhiteCard(context),
              _buildTabButtons(),
              Expanded(
                child: _buildLotteryList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildWhiteCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('สุ่มตัวเลข', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () => showCustomDialog(context),
                  child: Text('ล้างทั้งหมด', style: TextStyle(color: Colors.red[700], fontSize: 14)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.arrow_drop_down, color: Colors.black),
                Text('งวดวันที่ 16 สิงหาคม 2567', style: TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('Lotto ในระบบตอนนี้ ทั้งหมด ', style: TextStyle(fontSize: 14)),
                Text('$totalLotteries', style: TextStyle(fontSize: 14, color: Colors.amber)),
                Text(' ใบ', style: TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _generateNewLotteries,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : const Text('สุ่มตัวเลข', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.yellow,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.black, size: 24),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'ต้องการล้างข้อมูล\nทั้งหมดหรือไม่?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '(มั้ย?)',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                _buildCheckboxItem('ใบ lotto ทั้งหมด'),
                _buildCheckboxItem('ข้อมูลผู้ใช้ และ credit'),
                _buildCheckboxItem('รายการหวยที่ออก'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading ? null : _resetSystem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : const Text('บัดดิ้งๆ', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckboxItem(String label) {
    return Row(
      children: [
        Checkbox(
          value: true,
          onChanged: (bool? value) {
            // Handle checkbox state
          },
          activeColor: Colors.red,
        ),
        Text(label),
      ],
    );
  }

  Widget _buildTabButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _changeFilter('all'),
              style: ElevatedButton.styleFrom(
                backgroundColor: currentFilter == 'all' ? Colors.amber : Colors.white38,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('ทั้งหมด', style: TextStyle(color: currentFilter == 'all' ? Colors.black : Colors.white)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _changeFilter('sold'),
              style: ElevatedButton.styleFrom(
                backgroundColor: currentFilter == 'sold' ? Colors.amber : Colors.white38,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('ขายแล้ว', style: TextStyle(color: currentFilter == 'sold' ? Colors.black : Colors.white)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _changeFilter('unsold'),
              style: ElevatedButton.styleFrom(
                backgroundColor: currentFilter == 'unsold' ? Colors.amber : Colors.white38,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('ยังไม่ขาย', style: TextStyle(color: currentFilter == 'unsold' ? Colors.black : Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLotteryList() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: lotteries.length,
      itemBuilder: (context, index) {
        return _buildLotteryItem(lotteries[index]);
      },
    );
  }

  Widget _buildLotteryItem(Map<String, dynamic> lottery) {
    bool isSold = lottery['is_sold'] == true;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    lottery['number'] ?? '',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                color: isSold ? Colors.green : Colors.red,
                child: Icon(isSold ? Icons.person : Icons.close, color: Colors.white),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            color: Colors.black54,
            child: Text(
              isSold ? 'ขายแล้ว UserID: ${lottery['user_id'] ?? ''}' : 'ยังไม่ขาย',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LotteryAdminPage()),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.emoji_events, color: Colors.black),
                  Text('รางวัล', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.grid_4x4, color: Colors.black),
                Text('ระบบ', style: TextStyle(color: Colors.black)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resetSystem() async {
    setState(() {
      isLoading = true;
    });
    try {
      final result = await ApiService.resetSystem();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
      Navigator.of(context).pop(); // Close the dialog
      _refreshData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _generateNewLotteries() async {
    setState(() {
      isLoading = true;
    });
    try {
      final result = await ApiService.generateNewLotteries();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
      _refreshData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _refreshData() {
    fetchLotteries();
  }

  Future<void> fetchLotteries() async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedLotteries = await ApiService.getLotteries(
        skip: 0,
        limit: 100,
        filter: 'all', // เราจะดึงข้อมูลทั้งหมดมาก่อน
      );
      setState(() {
        if (currentFilter == 'all') {
          lotteries = fetchedLotteries;
        } else if (currentFilter == 'sold') {
          lotteries = fetchedLotteries.where((lottery) => lottery['is_sold'] == true).toList();
        } else if (currentFilter == 'unsold') {
          lotteries = fetchedLotteries.where((lottery) => lottery['is_sold'] != true).toList();
        }
        totalLotteries = fetchedLotteries.length; // จำนวนทั้งหมดยังคงเป็นจำนวนทั้งหมดที่มีในระบบ
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching lotteries: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _changeFilter(String filter) {
    setState(() {
      currentFilter = filter;
    });
    fetchLotteries();
  }
}