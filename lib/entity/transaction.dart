import 'package:floor/floor.dart';

@entity
class Transaction {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String desc;
  final int amount;
  final String category;
  final String? date;

  Transaction({ this.id,
    required this.desc,
    required this.amount,
    required this.category,
    this.date});
}
