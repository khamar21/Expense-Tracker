import '../../domain/entities/expense_entity.dart';

class ExpenseModel extends ExpenseEntity {
  ExpenseModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.category,
    required super.date,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "amount": amount,
        "category": category,
        "date": date.toIso8601String(),
      };

  factory ExpenseModel.fromJson(Map data) {
    return ExpenseModel(
      id: data["id"],
      title: data["title"],
      amount: data["amount"],
      category: data["category"],
      date: DateTime.parse(data["date"]),
    );
  }
}