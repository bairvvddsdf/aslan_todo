import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
enum TaskStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  inProcess,
  @HiveField(2)
  completed,
}

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime dateTime;

  @HiveField(3)
  TaskStatus status;

  @HiveField(4)
  DateTime createdAt;

  Task({
    required this.title,
    required this.description,
    required this.dateTime,
    required this.status,
    required this.createdAt,
  });
}
