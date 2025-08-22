import 'package:hive/hive.dart';

part 'income.g.dart';

@HiveType(typeId: 4)
class Income {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String source;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  Income({
    required this.id,
    required this.source,
    required this.amount,
    required this.date,
  });
}
