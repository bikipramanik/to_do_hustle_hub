import 'package:to_do_hustle_hub/models/section_model.dart';

class TaskStateModel {
  final List<SectionModel> sections;
  final int selectedIndex;
  final bool starWhileAddingTask;
  final bool addDescriptionWhileAddingTask;
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
