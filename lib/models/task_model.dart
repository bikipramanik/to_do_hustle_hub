import 'package:uuid/uuid.dart';

class TaskModel {
  static final uuid = Uuid();
  final String taskId;
  final String taskName;
  final String parentSectionId;
  final bool starred;
  final bool completed;

  TaskModel({
    String? taskId,
    required this.taskName,
    required this.parentSectionId,
    this.starred = false,
    this.completed = false,
  }) : taskId = taskId ?? uuid.v4();

  TaskModel copyWith({
    String? taskId,
    String? taskName,
    String? parentSectionId,
    bool? starred,
    bool? completed,
  }) {
    return TaskModel(
      taskId: taskId ?? this.taskId,
      taskName: taskName ?? this.taskName,
      parentSectionId: parentSectionId ?? this.parentSectionId,
      starred: starred ?? this.starred,
      completed: completed ?? this.completed,
    );
  }
}
