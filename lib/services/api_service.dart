import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://docker-lotto-pma.onrender.com';

  // static Future<Map<String, dynamic>> register(
  //     String username, String password, int wallet) async {
  //   final response = await http.post(
  //     Uri.parse('$baseUrl/register/'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       'username': username,
  //       'password': password,
  //       'wallet': wallet,
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body) as Map<String, dynamic>;
  //   } else {
  //     throw Exception('Failed to register: ${response.body}');
  //   }
  // }

  // static Future<Map<String, dynamic>> login(
  //     String username, String password) async {
  //   final response = await http.post(
  //     Uri.parse('$baseUrl/login/'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       'username': username,
  //       'password': password,
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body) as Map<String, dynamic>;
  //   } else {
  //     throw Exception('Failed to login: ${response.body}');
  //   }
  // }

  static Future<Map<String, dynamic>> register(
      String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> getLotteries(
      {int skip = 0, int limit = 100, required String filter}) async {
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

  static Future<Map<String, dynamic>> buyLottery(
      int userId, int lotteryId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/buy_lottery/$userId/$lotteryId/'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to buy lottery: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getWallet(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/wallet/$userId/'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
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
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to reset system: ${response.body}');
    }
  }

  // static Future<Map<String, dynamic>> editProfile(
  //     int userId, String newUsername, String newPassword) async {
  //   final response = await http.put(
  //     Uri.parse('$baseUrl/edit_profile/$userId/'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       'username': newUsername,
  //       'password': newPassword,
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body) as Map<String, dynamic>;
  //   } else {
  //     throw Exception('Failed to edit profile: ${response.body}');
  //   }
  // }

  static Future<Map<String, dynamic>> editProfile(int userId,
      String newUsername, String newEmail, String newPassword) async {
    final response = await http.put(
      Uri.parse('$baseUrl/edit_profile/$userId/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': newUsername,
        'email': newEmail,
        'password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to edit profile: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getUser(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/$userId/'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to get user: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> deposit(int userId, double amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/deposit/$userId/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': amount,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to deposit: ${response.body}');
    }
  }

  static Future<dynamic> getUserLotteries(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user_lotteries/$userId/'),
    );

    if (response.statusCode == 200) {
      final dynamic decodedResponse = jsonDecode(response.body);

      if (decodedResponse is List) {
        return decodedResponse.cast<Map<String, dynamic>>();
      } else if (decodedResponse is Map<String, dynamic>) {
        if (decodedResponse.containsKey('message')) {
          return {
            'message': decodedResponse['message'],
            'lotteries': (decodedResponse['lotteries'] as List?)
                    ?.cast<Map<String, dynamic>>() ??
                []
          };
        }
      }

      // If the response is neither a List nor a Map with 'message' key, return an empty list
      return [];
    } else {
      throw Exception('Failed to get user lotteries: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> generateNewLotteries() async {
    final response = await http.post(
      Uri.parse('$baseUrl/generate_new_lotteries/'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to generate new lotteries: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> claimWinningTicket(
      int userId, int ticketId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/claim_winning_ticket/$userId/$ticketId/'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to claim winning ticket: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> deleteLottery(
      int userId, int lotteryId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete_lottery/$userId/$lotteryId/'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to delete lottery: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> getUserWinningTickets(
      int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user_winning_tickets/$userId/'),
    );

    if (response.statusCode == 200) {
      List<dynamic> winningTickets = jsonDecode(response.body);
      return winningTickets.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to get user winning tickets: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllDrawsInfo() async {
    final response = await http.get(
      Uri.parse('$baseUrl/all_draws_info/'),
    );

    if (response.statusCode == 200) {
      List<dynamic> drawsInfo = jsonDecode(response.body);
      return drawsInfo.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to get all draws info: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/'),
    );

    if (response.statusCode == 200) {
      List<dynamic> users = jsonDecode(response.body);
      return users.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to get all users: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> queryDefaultWallet(int adminId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/query_default_wallet?admin_id=$adminId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to query default wallet: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> updateDefaultWallet(
      int adminId, int defaultWallet) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin/update_default_wallet?admin_id=$adminId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'default_wallet': defaultWallet,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to update default wallet: ${response.body}');
    }
  }
}
