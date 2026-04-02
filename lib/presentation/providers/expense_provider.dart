import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/expense_entity.dart';
import '../../data/remote/api_service.dart';

final expenseProvider =
    StateNotifierProvider<ExpenseNotifier, List<ExpenseEntity>>((ref) {
      return ExpenseNotifier();
    });

class ExpenseNotifier extends StateNotifier<List<ExpenseEntity>> {
  ExpenseNotifier() : super([]);

  final api = ApiService();

  Future<void> fetchExpenses() async {
    final data = await api.getExpenses();

    state = data.map((e) {
      final map = Map<String, dynamic>.from(e as Map);
      return ExpenseEntity(
        id: (map['id'] ?? map['_id'] ?? '').toString(),
        title: (map['title'] ?? '').toString(),
        amount: (map['amount'] is num)
            ? (map['amount'] as num).toDouble()
            : double.tryParse((map['amount'] ?? '0').toString()) ?? 0,
        category: (map['category'] ?? 'Other').toString(),
        date:
            DateTime.tryParse(
              (map['date'] ?? map['created_at'] ?? '').toString(),
            ) ??
            DateTime.now(),
      );
    }).toList();
  }

  Future<void> addExpense(ExpenseEntity expense) async {
    await api.addExpense({
      'title': expense.title,
      'amount': expense.amount,
      'category': expense.category,
    });

    await fetchExpenses();
  }
}
