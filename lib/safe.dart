import 'package:flutter/material.dart';
import 'package:lottorita888/home.dart';
import 'package:lottorita888/profile.dart';
import 'package:lottorita888/reward.dart';
import 'package:lottorita888/services/api_service.dart';

class SafePage extends StatefulWidget {
  final String userId;
  const SafePage({Key? key, required this.userId}) : super(key: key);

  @override
  _SafePageState createState() => _SafePageState();
}

class _SafePageState extends State<SafePage> {
  List<Map<String, dynamic>> lotteryItems = [];
  Map<String, dynamic> userData = {};
  bool isLoading = true;
  String errorMessage = '';
  List<Map<String, dynamic>> allDrawsInfo = [];
  String lotteryMessage = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      await Future.wait([
        fetchUserData(),
        fetchUserLotteries(),
        fetchAllDrawsInfo(),
      ]);
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load data. Please try again.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
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

  Future<void> fetchUserData() async {
    try {
      final user = await ApiService.getUser(int.parse(widget.userId));
      setState(() {
        userData = user;
      });
    } catch (e) {
      print('Error fetching user data: $e');
      throw Exception('Failed to load user data');
    }
  }

  Future<void> fetchUserLotteries() async {
    try {
      final dynamic result = await ApiService.getUserLotteries(int.parse(widget.userId));
      setState(() {
        if (result is List) {
          lotteryItems = _processLotteryList(result as List);
        } else if (result is Map<String, dynamic>) {
          lotteryMessage = result['message'] ?? '';
          lotteryItems = _processLotteryMap(result);
        } else {
          throw Exception('Unexpected response format');
        }
      });
    } catch (e) {
      print('Error fetching user lotteries: $e');
      throw Exception('Failed to load lotteries');
    }
  }

  List<Map<String, dynamic>> _processLotteryList(List result) {
    return result.map<Map<String, dynamic>>((lottery) {
      String message = _getLotteryMessage(lottery);
      return {
        'id': lottery['id'],
        'number': lottery['number'] ?? 'Unknown',
        'message': message,
        'isWinner': lottery['is_winner'] == true,
        'prizeTier': lottery['prize_tier'],
        'prizeAmount': lottery['prize_amount'],
        'isActive': lottery['is_active'],
      };
    }).toList();
  }

  List<Map<String, dynamic>> _processLotteryMap(Map<String, dynamic> result) {
    final lotteries = result['lotteries'];
    if (lotteries is List) {
      return lotteries.map<Map<String, dynamic>>((lottery) {
        String message = _getLotteryMessage(lottery);
        return {
          'id': lottery['id'],
          'number': lottery['number'] ?? 'Unknown',
          'message': message,
          'isWinner': lottery['is_winner'] == true,
          'prizeTier': lottery['prize_tier'],
          'prizeAmount': lottery['prize_amount'],
          'isActive': lottery['is_active'],
        };
      }).toList();
    } else {
      return [];
    }
  }

  String _getLotteryMessage(Map<String, dynamic> lottery) {
    if (lottery['is_winner'] == true) {
      return 'ยินดีด้วย คุณถูกรางวัล';
    } else if (lottery['draw_id'] != null) {
      return 'เสียใจด้วย คุณไม่ถูกรางวัล';
    } else {
      return 'รอประกาศรางวัล';
    }
  }

  Future<void> fetchAllDrawsInfo() async {
    try {
      final dynamic result = await ApiService.getAllDrawsInfo();
      if (result is List) {
        allDrawsInfo = result.map((draw) => draw as Map<String, dynamic>).toList();
        updateUserWalletForWinningTickets();
      } else {
        throw Exception('Unexpected response format for draws info');
      }
    } catch (e) {
      print('Error fetching all draws info: $e');
      throw Exception('Failed to load draws information');
    }
  }

  void updateUserWalletForWinningTickets() {
    for (var draw in allDrawsInfo) {
      final winningTickets = draw['winning_tickets'];
      if (winningTickets is List) {
        for (var ticket in winningTickets) {
          if (ticket['owner_id'].toString() == widget.userId && ticket['is_claimed'] == false) {
            int prizeAmount = ticket['prize_amount'] ?? 0;
            setState(() {
              userData['wallet'] = (userData['wallet'] ?? 0) + prizeAmount;
            });
            claimWinningTicket(ticket['id'], prizeAmount);
          }
        }
      }
    }
  }

  Future<void> claimWinningTicket(int ticketId, int prizeAmount) async {
    try {
      final result = await ApiService.claimWinningTicket(int.parse(widget.userId), ticketId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${result['message'] ?? 'Winning ticket claimed successfully'}\nยอดคงเหลือ: ${userData['wallet']} บาท')),
      );
      for (var draw in allDrawsInfo) {
        final winningTickets = draw['winning_tickets'];
        if (winningTickets is List) {
          for (var ticket in winningTickets) {
            if (ticket['id'] == ticketId) {
              ticket['is_claimed'] = true;
              break;
            }
          }
        }
      }
      await deleteLottery(ticketId);
    } catch (e) {
      print('Error claiming winning ticket: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to claim winning ticket. Please try again.')),
      );
    }
  }

  Future<void> deleteLottery(int lotteryId) async {
    try {
      await ApiService.deleteLottery(int.parse(widget.userId), lotteryId);
      setState(() {
        lotteryItems.removeWhere((item) => item['id'] == lotteryId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lottery ticket deleted successfully')),
      );
    } catch (e) {
      print('Error deleting lottery: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete lottery. Please try again.')),
      );
    }
  }

  Widget _buildHeader() {
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
                const Icon(Icons.account_balance_wallet, color: Colors.amber, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${userData['wallet'] ?? 0}',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage, style: TextStyle(color: Colors.white)),
            ElevatedButton(
              onPressed: _loadData,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (lotteryItems.isEmpty) {
      return Center(child: Text('No lotteries found', style: TextStyle(color: Colors.white)));
    }
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        itemCount: lotteryItems.length,
        itemBuilder: (context, index) {
          final item = lotteryItems[index];
          return _buildLotteryItem(
            item['number'],
            item['message'],
            item['isWinner'],
            item['prizeTier'],
            item['prizeAmount'],
            index,
          );
        },
      ),
    );
  }

  Widget _buildLotteryItem(String? number, String message, bool isWinner, int? prizeTier, int? prizeAmount, int index) {
    final item = lotteryItems[index];
    final ticketId = item['id'];
    final isActive = item['isActive'];

    return GestureDetector(
      onTap: () {
        if (isWinner) {
          _showWinningDialog(context, number ?? 'Unknown', ticketId, prizeTier, prizeAmount);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? Colors.amber : Colors.grey,
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
                      number ?? 'Unknown',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: _getMessageColor(message),
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
              color: _getStatusColor(isWinner, message),
              child: _getStatusIcon(isWinner, message, ticketId),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMessageColor(String message) {
    if (message == 'รอประกาศรางวัล') return Colors.blue;
    if (message.contains('ยินดีด้วย')) return Colors.green;
    return Colors.red;
  }

  Color _getStatusColor(bool isWinner, String message) {
    if (message == 'รอประกาศรางวัล') return Colors.blue;
    if (isWinner) return Colors.green;
    return Colors.red;
  }

  Widget _getStatusIcon(bool isWinner, String message, int ticketId) {
    if (message == 'รอประกาศรางวัล') {
      return Icon(Icons.access_time, color: Colors.white);
    }
    if (isWinner) {
      return Icon(Icons.check, color: Colors.white);
    }
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.white),
      onPressed: () => _showDeleteConfirmation(context, ticketId),
    );
  }

  void _showWinningDialog(BuildContext context, String winningNumbers, int ticketId, int? prizeTier, int? prizeAmount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Credit', style: TextStyle(color: Colors.grey)),
                            Text('อันดับ $prizeTier', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text('+$prizeAmount', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ยอดคงเหลือ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${userData['wallet']}.-', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      child: const Text('ยืนยัน'),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await claimWinningTicket(ticketId, prizeAmount ?? 0);
                        setState(() {
                          lotteryItems.removeWhere((item) => item['id'] == ticketId);
                        });
                      },
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
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, int ticketId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Lottery Ticket'),
          content: Text('Are you sure you want to delete this lottery ticket?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                deleteLottery(ticketId);
              },
            ),
          ],
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
          _buildNavItem(Icons.calendar_today, 'หวย', () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage(userId: widget.userId)),
            );
          }),
          _buildNavItem(Icons.emoji_events, 'รางวัล', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RewardPage(userId: widget.userId)),
            );
          }),
          _buildNavItem(Icons.person, 'บัญชี', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SafePage(userId: widget.userId)),
            );
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