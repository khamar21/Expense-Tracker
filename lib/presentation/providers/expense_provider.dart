import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/expense_entity.dart';
import '../../data/repositories/expense_repository_impl.dart';

class ExpenseNotifier extends StateNotifier<List<ExpenseEntity>> {
  ExpenseNotifier() : super([]) {
    load();
  }

  final repo = ExpenseRepositoryImpl();

  void load() {
    state = repo.getExpenses();
  }

  void addExpense(ExpenseEntity e) {
    repo.addExpense(e);
    load();
  }

  void deleteExpense(int index) {
    repo.deleteExpense(index);
    load();
  }

  double get total =>
      state.fold(0, (sum, e) => sum + e.amount);
}

final expenseProvider =
    StateNotifierProvider<ExpenseNotifier, List<ExpenseEntity>>(
        (ref) => ExpenseNotifier());