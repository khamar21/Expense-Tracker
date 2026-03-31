import '../entities/expense_entity.dart';

abstract class ExpenseRepository {
  List<ExpenseEntity> getExpenses();
  void addExpense(ExpenseEntity expense);
  void deleteExpense(int index);
}