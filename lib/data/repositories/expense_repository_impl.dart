import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/local/hive_service.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final hive = HiveService();

  @override
  List<ExpenseEntity> getExpenses() {
    return hive.getAll().map((e) {
      return ExpenseModel.fromJson(Map<String, dynamic>.from(e));
    }).toList();
  }

  @override
  void addExpense(ExpenseEntity expense) {
    final model = ExpenseModel(
      id: expense.id,
      title: expense.title,
      amount: expense.amount,
      category: expense.category,
      date: expense.date,
    );
    hive.add(model.toJson());
  }

  @override
  void deleteExpense(int index) {
    hive.delete(index);
  }
}