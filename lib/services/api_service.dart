import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://docker-lotto-pma.onrender.com';

  static Future<Map<String, dynamic>> register(String username, String password, int wallet) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'wallet': wallet,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> getLotteries({int skip = 0, int limit = 100}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/lotteries/?skip=$skip&limit=$limit'),
    );

    if (response.statusCode == 200) {
      List<dynamic> lotteries = jsonDecode(response.body);
      return lotteries.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to get lotteries: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> buyLottery(int userId, int lotteryId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/buy_lottery/$userId/$lotteryId/'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to buy lottery: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getWallet(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/wallet/$userId/'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get wallet: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> drawLottery() async {
    final response = await http.post(
      Uri.parse('$baseUrl/draw/'),
    );

    if (response.statusCode == 200) {
      List<dynamic> winners = jsonDecode(response.body);
      return winners.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to draw lottery: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> resetSystem() async {
    final response = await http.post(
      Uri.parse('$baseUrl/reset/'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to reset system: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> editProfile(int userId, String newUsername, String newPassword) async {
    final response = await http.put(
      Uri.parse('$baseUrl/edit_profile/$userId/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': newUsername,
        'password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to edit profile: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getUser(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/$userId/'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user: ${response.body}');
    }
  }
}