import 'package:to_do_hustle_hub/models/task_model.dart';
import 'package:uuid/uuid.dart';

class SectionModel {
  static final uuid = Uuid();
  final String sectionId;
  final String sectionName;
  final List<TaskModel> tasks;
  final List<TaskModel> completedTasks;

  SectionModel({
    String? sectionId,
    required this.sectionName,
    
    List<TaskModel>? tasks,
    List<TaskModel>? completedTasks,
  }) : sectionId = sectionId ?? uuid.v4(),
       tasks = tasks ?? [],
       completedTasks = completedTasks ?? [];

  SectionModel copyWith({
    String? sectionName,

    List<TaskModel>? tasks,
    List<TaskModel>? completedTasks,
  }) {
    return SectionModel(
      sectionId: sectionId,
      sectionName: sectionName ?? this.sectionName,
      tasks: tasks ?? this.tasks,
      completedTasks: completedTasks ?? this.completedTasks,
    );
  }
}
