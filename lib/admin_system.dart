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
  int defaultWallet = 0;
  TextEditingController defaultWalletController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchLotteries();
    fetchDefaultWallet();
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
                const Text('สุ่มตัวเลข',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () => showCustomDialog(context),
                  child: Text('ล้างทั้งหมด',
                      style: TextStyle(
                          color: Colors.red[700],
                          fontSize: 14,
                          fontFamily: 'Kanit')),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text('Lotto ในระบบตอนนี้ ทั้งหมด ',
                    style: TextStyle(fontSize: 14, fontFamily: 'Kanit')),
                Text('$totalLotteries',
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.amber,
                        fontFamily: 'Kanit')),
                const Text(' ใบ',
                    style: TextStyle(fontSize: 14, fontFamily: 'Kanit')),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 500,
              height: 60,
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
                    : const Text('สุ่มตัวเลข',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Kanit')),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: defaultWalletController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Default Wallet',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _updateDefaultWallet,
                  child: Text('Update'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Current Default Wallet: $defaultWallet'),
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
                        child: const Icon(Icons.close,
                            color: Colors.black, size: 24),
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
                      : const Text('บัดตึงๆ',
                          style: TextStyle(color: Colors.white)),
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
                backgroundColor: currentFilter == 'all'
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : Colors.white38,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('ทั้งหมด',
                  style: TextStyle(
                      color: currentFilter == 'all'
                          ? Colors.black
                          : Colors.white)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _changeFilter('sold'),
              style: ElevatedButton.styleFrom(
                backgroundColor: currentFilter == 'sold'
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : Colors.white38,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('ขายแล้ว',
                  style: TextStyle(
                      color: currentFilter == 'sold'
                          ? const Color.fromARGB(255, 0, 0, 0)
                          : Colors.white)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _changeFilter('unsold'),
              style: ElevatedButton.styleFrom(
                backgroundColor: currentFilter == 'unsold'
                    ? const Color.fromARGB(255, 247, 247, 247)
                    : Colors.white38,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('ยังไม่ขาย',
                  style: TextStyle(
                      color: currentFilter == 'unsold'
                          ? Colors.black
                          : Colors.white)),
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
          gradient: const LinearGradient(
            colors: [
              Color(0xFFF7EF8A),
              Color(0xFFE0AA3E),
              Color(0xFFF7EF8A),
              Color(0xFFE0AA3E),
            ],
            stops: [0.0, 0.5, 1.5, 2.5],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    lottery['number'] ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Kanit',
                      letterSpacing: 10.0,
                    ),
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 70,
                decoration: BoxDecoration(
                  color: isSold ? Colors.green : Colors.red,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Icon(
                  isSold ? Icons.person : Icons.close,
                  color: Colors.white,
                ),
              )
            ],
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: const BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Text(
              isSold ? 'ขายแล้ว' : 'ยังไม่ขาย',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF7EF8A),
            Color(0xFFE0AA3E),
            Color(0xFFF7EF8A),
            Color(0xFFE0AA3E),
          ],
          stops: [0.0, 0.5, 1.5, 2.5],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
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
    fetchDefaultWallet();
  }

  Future<void> fetchLotteries() async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedLotteries = await ApiService.getLotteries(
        skip: 0,
        limit: 100,
        filter: 'all',
      );
      setState(() {
        if (currentFilter == 'all') {
          lotteries = fetchedLotteries;
        } else if (currentFilter == 'sold') {
          lotteries = fetchedLotteries
              .where((lottery) => lottery['is_sold'] == true)
              .toList();
        } else if (currentFilter == 'unsold') {
          lotteries = fetchedLotteries
              .where((lottery) => lottery['is_sold'] != true)
              .toList();
        }
        totalLotteries = fetchedLotteries.length;
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

  Future<void> fetchDefaultWallet() async {
    try {
      final result = await ApiService.queryDefaultWallet(5); // Assuming admin_id is 1
      setState(() {
        defaultWallet = result['default_wallet'];
        defaultWalletController.text = defaultWallet.toString();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching default wallet: $e')),
      );
    }
  }

  Future<void> _updateDefaultWallet() async {
    try {
      int newDefaultWallet = int.parse(defaultWalletController.text);
      final result = await ApiService.updateDefaultWallet(5, newDefaultWallet); // Assuming admin_id is 1
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
      fetchDefaultWallet();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating default wallet: $e')),
      );
    }
  }
}