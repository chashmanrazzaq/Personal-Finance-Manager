import 'package:hive/hive.dart';

part 'goal.g.dart';

@HiveType(typeId: 3)
class Goal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double targetAmount;

  @HiveField(3)
  double savedAmount;

  @HiveField(4)
  double currentAmount;

  Goal({
    required this.id,
    required this.title,
    required this.targetAmount,
    this.savedAmount = 0.0,
    this.currentAmount = 0,
  });
}
