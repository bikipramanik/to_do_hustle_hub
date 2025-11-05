import 'package:to_do_hustle_hub/models/task_model.dart';
import 'package:uuid/uuid.dart';

class SectionModel {
  static final uuid = Uuid();
  final String sectionId;
  final String sectionName;
  final String? sectionDescription;
  final List<TaskModel> tasks;
  final List<TaskModel> completedTasks;

  SectionModel({
    String? sectionId,
    required this.sectionName,
    this.sectionDescription,
    List<TaskModel>? tasks,
    List<TaskModel>? completedTasks,
  }) : sectionId = sectionId ?? uuid.v4(),
       tasks = tasks ?? [],
       completedTasks = completedTasks ?? [];

  SectionModel copyWith({
    String? sectionName,
    String? sectionDescription,

    List<TaskModel>? tasks,
    List<TaskModel>? completedTasks,
  }) {
    return SectionModel(
      sectionId: sectionId,
      sectionName: sectionName ?? this.sectionName,
      sectionDescription: sectionDescription ?? this.sectionDescription,
      tasks: tasks ?? this.tasks,
      completedTasks: completedTasks ?? this.completedTasks,
    );
  }
}
