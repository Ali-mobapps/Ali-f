import 'package:intl/intl.dart';

enum Category { food, travel, leisure, work }

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  String get formattedDate {
    return DateFormat.yMd().format(date);
  }
}