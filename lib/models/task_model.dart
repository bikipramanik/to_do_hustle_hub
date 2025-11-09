import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel {
  static final uuid = Uuid();

  @HiveField(0)
  final String taskId;

  @HiveField(1)
  final String taskName;

  @HiveField(2)
  final String? taskDescription;

  @HiveField(3)
  final String parentSectionId;

  @HiveField(4)
  final bool starred;

  @HiveField(5)
  final bool completed;

  TaskModel({
    String? taskId,
    required this.taskName,
    this.taskDescription,
    required this.parentSectionId,
    this.starred = false,
    this.completed = false,
  }) : taskId = taskId ?? uuid.v4();

  TaskModel copyWith({
    String? taskId,
    String? taskName,
    String? taskDescription,
    String? parentSectionId,
    bool? starred,
    bool? completed,
  }) {
    return TaskModel(
      taskId: taskId ?? this.taskId,
      taskName: taskName ?? this.taskName,
      taskDescription: taskDescription ?? this.taskDescription,
      parentSectionId: parentSectionId ?? this.parentSectionId,
      starred: starred ?? this.starred,
      completed: completed ?? this.completed,
    );
  }
}
