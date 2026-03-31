import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  /// ADD EXPENSE
  static Future<void> addExpense(String title, double amount) async {
    await http.post(
      Uri.parse('$baseUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'amount': amount}),
    );
  }

  /// GET EXPENSES
  static Future<List<dynamic>> getExpenses() async {
    final response = await http.get(Uri.parse('$baseUrl/all'));
    return jsonDecode(response.body) as List<dynamic>;
  }
}
