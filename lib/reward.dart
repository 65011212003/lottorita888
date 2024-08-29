import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottorita888/home.dart';
import 'package:lottorita888/safe.dart';
import 'package:lottorita888/services/api_service.dart';
import 'package:intl/intl.dart';

class RewardPage extends StatefulWidget {
  final String userId;
  const RewardPage({Key? key, required this.userId}) : super(key: key);

  @override
  _RewardPageState createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  List<Map<String, dynamic>> _drawsInfo = [];
  bool _isLoading = true;
  Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final drawsInfo = await ApiService.getAllDrawsInfo();
      final userData = await ApiService.getUser(int.parse(widget.userId));
      setState(() {
        _drawsInfo = drawsInfo;
        _userData = userData;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
        _userData = {};
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch data: $e')),
        );
      }
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    _buildHeader(),
                    _buildDateDisplay(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: _buildRewardsList(),
                      ),
                    ),
                    _buildBottomNavBar(context),
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
          GestureDetector(
            onTap: () {
              // Navigate to profile page
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                (_userData['username'] as String?)?.isNotEmpty == true
                    ? (_userData['username'] as String).substring(0, 1).toUpperCase()
                    : 'U',
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
                  '${_userData['wallet'] ?? 0}',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateDisplay() {
    if (_drawsInfo.isEmpty) return SizedBox.shrink();
    final drawDate = DateTime.parse(_drawsInfo[0]['draw_date']);
    final formattedDate = DateFormat('d MMMM y').format(drawDate);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        'งวดวันที่ $formattedDate',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _buildRewardsList() {
    if (_drawsInfo.isEmpty) {
      return const Center(child: Text('No lottery results available.', style: TextStyle(color: Colors.white)));
    }

    final latestDraw = _drawsInfo[0];
    final winningTickets = latestDraw['winning_tickets'] as List<dynamic>;
    final prizeTiers = latestDraw['prize_tiers'] as List<dynamic>;

    return Column(
      children: List.generate(5, (index) {
        final tier = index + 1;
        final winningTicket = winningTickets.firstWhere((ticket) => ticket['prize_tier'] == tier, orElse: () => null);
        final prizeTier = prizeTiers.firstWhere((prize) => prize['tier'] == tier, orElse: () => null);

        if (winningTicket == null || prizeTier == null) return SizedBox.shrink();

        return _buildRewardCard(
          'รางวัลที่ $tier',
          winningTicket['number'],
          'รางวัล ${NumberFormat('#,###').format(prizeTier['amount'])} บาท',
          isSmall: tier > 3,
        );
      }),
    );
  }

  Widget _buildRewardCard(String title, String numbers, String prize, {bool isSmall = false}) {
    final cardWidth = isSmall ? MediaQuery.of(context).size.width * 0.43 : double.infinity;

    return Container(
      width: cardWidth,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: TextStyle(fontSize: isSmall ? 16 : 18, fontWeight: FontWeight.bold)),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: isSmall ? 12 : 16),
            color: Colors.white,
            child: Center(
              child: Text(
                numbers,
                style: TextStyle(
                  fontSize: isSmall ? 20 : 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: isSmall ? 4 : 8,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(prize, style: TextStyle(fontSize: isSmall ? 14 : 16)),
          ),
        ],
      ),
    );
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
              MaterialPageRoute(builder: (context) => HomePage(userId: widget.userId)),
            );
          }),
          _buildNavItem(context, Icons.emoji_events, 'รางวัล', () {
            // Already on the RewardPage, so no navigation needed
          }),
          _buildNavItem(context, Icons.person, 'บัญชี', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SafePage(userId: widget.userId)),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, VoidCallback onTap) {
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