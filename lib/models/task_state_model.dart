import 'package:hive_flutter/adapters.dart';
import 'package:to_do_hustle_hub/models/section_model.dart';

part 'task_state_model.g.dart';

@HiveType(typeId: 2)
class TaskStateModel {
  @HiveField(0)
  final List<SectionModel> sections;
  @HiveField(1)
  final int selectedIndex;
  @HiveField(2)
  final bool starWhileAddingTask;
  @HiveField(3)
  final bool addDescriptionWhileAddingTask;
  @HiveField(4)
  final bool showCompletedTask;

  TaskStateModel({
    required this.sections,
    this.selectedIndex = 1,
    this.starWhileAddingTask = false,
    this.addDescriptionWhileAddingTask = false,
    this.showCompletedTask = false,
  });

  TaskStateModel copyWith({
    List<SectionModel>? sections,
    int? selectedIndex,
    bool? starWhileAddingTask,
    bool? addDescriptionWhileAddingTask,
    bool? showCompletedTask,
  }) {
    return TaskStateModel(
      sections: sections ?? this.sections,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      addDescriptionWhileAddingTask:
          addDescriptionWhileAddingTask ?? this.addDescriptionWhileAddingTask,
      showCompletedTask: showCompletedTask ?? this.showCompletedTask,
      starWhileAddingTask: starWhileAddingTask ?? this.starWhileAddingTask,
    );
  }
}
