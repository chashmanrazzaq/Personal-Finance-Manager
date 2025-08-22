import 'package:hive/hive.dart';

part 'budget.g.dart';

@HiveType(typeId: 1)
class Budget extends HiveObject {
  @HiveField(0)
  final String category;

  @HiveField(1)
  final double limit;

  Budget({required this.category, required this.limit});
}
