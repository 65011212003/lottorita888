import 'package:flutter/material.dart';
import 'package:lottorita888/home.dart';
import 'package:lottorita888/profile.dart';
import 'package:lottorita888/reward.dart';
import 'package:lottorita888/services/api_service.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class SafePage extends StatefulWidget {
  final String userId;
  const SafePage({Key? key, required this.userId}) : super(key: key);

  @override
  _SafePageState createState() => _SafePageState();
}

class _SafePageState extends State<SafePage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> lotteryItems = [];
  Map<String, dynamic> userData = {};
  bool isLoading = true;
  String errorMessage = '';
  List<Map<String, dynamic>> allDrawsInfo = [];
  String lotteryMessage = '';
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
      final result =
          await ApiService.getUserLotteries(int.parse(widget.userId));
      setState(() {
        if (result is List) {
          lotteryItems =
              _processLotteryList(result.cast<Map<String, dynamic>>());
          lotteryMessage = '';
        } else if (result is Map<String, dynamic>) {
          lotteryMessage = result['message'] ?? '';
          final lotteries = result['lotteries'];
          if (lotteries is List) {
            lotteryItems =
                _processLotteryList(lotteries.cast<Map<String, dynamic>>());
          } else {
            lotteryItems = [];
          }
        } else {
          lotteryItems = [];
          lotteryMessage = 'Unexpected response format';
        }
      });
    } catch (e) {
      print('Error fetching user lotteries: $e');
      setState(() {
        lotteryItems = [];
        lotteryMessage = 'Failed to load lotteries';
      });
    }
  }

  List<Map<String, dynamic>> _processLotteryList(
      List<Map<String, dynamic>> lotteries) {
    return lotteries.map((lottery) {
      return {
        'id': lottery['id'],
        'number': lottery['number']?.toString() ?? 'Unknown',
        'state': lottery['state'] ?? 'unknown',
        'prizeTier': lottery['prize_tier']?.toString() ?? 'Unknown',
        'prizeAmount': lottery['prize_amount'] ?? 0,
        'isActive': lottery['is_active'],
        'isClaimed': lottery['is_claimed'] ?? false,
      };
    }).toList();
  }

  Future<void> fetchAllDrawsInfo() async {
    try {
      final result = await ApiService.getAllDrawsInfo();
      setState(() {
        allDrawsInfo = result.map((draw) {
          return Map<String, dynamic>.from(draw).map((key, value) {
            if (value == null) {
              return MapEntry(key, 0); // Replace null with 0 for numeric fields
            }
            if (value is int?) {
              return MapEntry(
                  key, value ?? 0); // Use 0 as default for nullable ints
            }
            return MapEntry(key, value);
          });
        }).toList();
      });
    } catch (e) {
      print('Error fetching all draws info: $e');
      setState(() {
        allDrawsInfo = [];
      });
    }
  }

  void updateUserWalletForWinningTickets() {
    for (var draw in allDrawsInfo) {
      final winningTickets = draw['winning_tickets'];
      if (winningTickets is List) {
        for (var ticket in winningTickets) {
          if (ticket['owner_id'].toString() == widget.userId &&
              ticket['is_claimed'] == false) {
            int prizeAmount = ticket['prize_amount'] ?? 0;
            setState(() {
              userData['wallet'] = (userData['wallet'] ?? 0) + prizeAmount;
              // Update the corresponding lottery item
              var lotteryItem = lotteryItems.firstWhere(
                (item) => item['id'] == ticket['id'],
                orElse: () => {},
              );
              if (lotteryItem.isNotEmpty) {
                lotteryItem['state'] = 'win';
                lotteryItem['prizeTier'] =
                    ticket['prize_tier']?.toString() ?? 'Unknown';
                lotteryItem['prizeAmount'] = prizeAmount;
              }
            });
            claimWinningTicket(ticket['id'], prizeAmount);
          }
        }
      }
    }
  }

  Future<void> claimWinningTicket(int ticketId, int prizeAmount) async {
    try {
      final result = await ApiService.claimWinningTicket(
          int.parse(widget.userId), ticketId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${result['message'] ?? 'Winning ticket claimed successfully'}\nยอดคงเหลือ: ${userData['wallet']} บาท')),
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
    } catch (e) {
      print('Error claiming winning ticket: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to claim winning ticket. Please try again.')),
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
        const SnackBar(
            content: Text('Failed to delete lottery. Please try again.')),
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
                _buildTitle(),
                _buildDateDisplay(),
                Expanded(
                  child: _buildLotteryList(),
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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(userId: widget.userId),
                ),
              );
            },
            child: Hero(
              tag: 'profileAvatar',
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  userData['username']?.substring(0, 1).toUpperCase() ?? 'U',
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet,
                    color: Colors.amber, size: 24),
                const SizedBox(width: 8),
                Text(
                  '${userData['wallet'] ?? 0}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
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
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        'ดูโพย',
        style: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 10.0,
              color: Colors.black,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'งวดวันที่ 16 สิงหาคม 2567',
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildLotteryList() {
    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber)));
    }
    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage,
                style: const TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }
    if (lotteryItems.isEmpty) {
      return const Center(
          child: Text('No lotteries found',
              style: TextStyle(color: Colors.white, fontSize: 18)));
    }
    return RefreshIndicator(
      onRefresh: _loadData,
      child: AnimationLimiter(
        child: ListView.builder(
          itemCount: lotteryItems.length,
          itemBuilder: (context, index) {
            final item = lotteryItems[index];
            if (item['isClaimed'] != true) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: _buildLotteryItem(item, index),
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget _buildLotteryItem(Map<String, dynamic> item, int index) {
    final number = item['number'];
    final state = item['state'];
    final prizeTier = item['prizeTier'];
    final prizeAmount = item['prizeAmount'];
    final ticketId = item['id'];
    final isActive = item['isActive'];
    final isClaimed = item['isClaimed'];

    return GestureDetector(
      onTap: () {
        if (state == 'win' && !isClaimed) {
          _showWinningDialog(context, number, ticketId, prizeTier, prizeAmount);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: isActive ? Colors.amber.shade300 : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      number,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _getMessageColor(state),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    child: Text(
                      _getStateMessage(state),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 70,
              height: 120,
              decoration: BoxDecoration(
                color: _getStatusColor(state),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (state == 'lose')
                    IconButton(
                      icon: const Icon(Icons.close,
                          color: Colors.white, size: 28),
                      onPressed: () => deleteLottery(ticketId),
                    ),
                  if (state != 'lose') const SizedBox(height: 60),
                  _getStatusIcon(state, isClaimed, ticketId, number, prizeTier,
                      prizeAmount),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMessageColor(String state) {
    switch (state) {
      case 'win':
        return Colors.green;
      case 'lose':
        return Colors.red;
      case 'waiting':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getStateMessage(String state) {
    switch (state) {
      case 'win':
        return 'ยินดีด้วย คุณถูกรางวัล';
      case 'lose':
        return 'เสียใจด้วย คุณไม่ถูกรางวัล';
      case 'waiting':
        return 'รอประกาศรางวัล';
      default:
        return 'สถานะไม่ทราบ';
    }
  }

  Color _getStatusColor(String state) {
    switch (state) {
      case 'win':
        return Colors.green;
      case 'lose':
        return Colors.red;
      case 'waiting':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _getStatusIcon(String state, bool isClaimed, int ticketId,
      String number, String? prizeTier, int? prizeAmount) {
    switch (state) {
      case 'win':
        return IconButton(
          icon: const Icon(Icons.emoji_events, color: Colors.white),
          onPressed: isClaimed
              ? null
              : () => _showWinningDialog(
                  context, number, ticketId, prizeTier, prizeAmount),
        );
      case 'lose':
        return const Icon(Icons.close, color: Colors.white);
      case 'waiting':
        return const Icon(Icons.access_time, color: Colors.white);
      default:
        return const Icon(Icons.help_outline, color: Colors.white);
    }
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      color: Colors.amber,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, Icons.calendar_today, 'หวย', () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(userId: widget.userId)),
            );
          }),
          _buildNavItem(context, Icons.emoji_events, 'รางวัล', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RewardPage(userId: widget.userId)),
            );
          }),
          _buildNavItem(context, Icons.person, 'บัญชี', () {}),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
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

  void _showWinningDialog(BuildContext context, String number, int ticketId,
      String? prizeTier, int? prizeAmount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'ขึ้นรางวัล',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'เลขที่ถูกรางวัล: $number',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'รางวัลที่ได้: ${prizeTier ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await claimWinningTicket(ticketId, prizeAmount ?? 0);
                    setState(() {
                      // Refresh the page
                      _loadData();
                    });
                  },
                  child: const Text('รับรางวัล'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
