import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.31.37:8000";

  Future<List<dynamic>> getExpenses() async {
    final res = await http.get(Uri.parse('$baseUrl/expenses/'));
    if (res.statusCode != 200) {
      throw Exception(
        'Failed to fetch expenses: ${res.statusCode} ${res.body}',
      );
    }

    return jsonDecode(res.body) as List<dynamic>;
  }

  Future<void> addExpense(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/expenses/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Failed to add expense: ${res.statusCode} ${res.body}');
    }
  }
}
