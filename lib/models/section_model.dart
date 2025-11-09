import 'package:hive_flutter/adapters.dart';
import 'package:to_do_hustle_hub/models/task_model.dart';
import 'package:uuid/uuid.dart';


part 'section_model.g.dart';

@HiveType(typeId: 1)
class SectionModel {
  static final uuid = Uuid();
  @HiveField(0)
  final String sectionId;
  @HiveField(1)
  final String sectionName;
  @HiveField(2)
  final List<TaskModel> tasks;
  @HiveField(3)
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
