import 'package:flutter/material.dart';
import 'package:lottorita888/admin_home.dart';

class SystemAdminPage extends StatelessWidget {
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
            const Row(
              children: [
                Text('Lotto ในระบบตอนนี้ ทั้งหมด ', style: TextStyle(fontSize: 14)),
                Text('100', style: TextStyle(fontSize: 14, color: Colors.amber)),
                Text(' ใบ', style: TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('สุ่มตัวเลข', style: TextStyle(color: Colors.white)),
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
                  onPressed: () {
                    // Handle clear action
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('บัดดิ้งๆ', style: TextStyle(color: Colors.white)),
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('ทั้งหมด', style: TextStyle(color: Colors.black)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white38,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('ขายแล้ว', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white38,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('ยังไม่ขาย', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLotteryList() {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return _buildLotteryItem(index);
      },
    );
  }

  Widget _buildLotteryItem(int index) {
    bool isSold = index % 2 == 1;
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
                    index == 3 ? '1 1 1 1 1 1' : '5 ${index + 3} 3 2 ${index == 0 ? '2 2' : '1 ${index + 1}'}',
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
              isSold ? 'ขายแล้ว UserID: 1' : 'ยังไม่ขาย',
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
}