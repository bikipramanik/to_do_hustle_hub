import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:to_do_hustle_hub/models/section_model.dart';
import 'package:to_do_hustle_hub/models/task_model.dart';
import 'package:to_do_hustle_hub/models/task_state_model.dart';
import 'package:to_do_hustle_hub/utils/dummy_data.dart';

class TaskManager extends StateNotifier<TaskStateModel> {
  TaskManager() : super(dummyData);

  void toggleAddDescriptionWhileAddingTask({bool? reset}) {
    if (reset == true) {
      debugPrint(
        "--Resetting Desc----------${state.addDescriptionWhileAddingTask}",
      );
      state = state.copyWith(addDescriptionWhileAddingTask: false);
      return;
    }
    debugPrint("----------------------${state.addDescriptionWhileAddingTask}");
    state = state.copyWith(
      addDescriptionWhileAddingTask: !state.addDescriptionWhileAddingTask,
    );
    debugPrint("----------------------${state.addDescriptionWhileAddingTask}");
  }

  void toggleMarkStarWhileAddingTask({bool? reset}) {
    if (reset == true) {
      debugPrint("--Resetting Star----------${state.starWhileAddingTask}");
      state = state.copyWith(starWhileAddingTask: false);
      return;
    }
    debugPrint("----------------------${state.starWhileAddingTask}");

    state = state.copyWith(starWhileAddingTask: !state.starWhileAddingTask);
    debugPrint("----------------------${state.starWhileAddingTask}");
  }

  //change Screen
  void changeScreen(int index) {
    final newState = state.copyWith(selectedIndex: index);
    state = newState;
  }

  //delete section
  void deleteSection(int index) {
    if (index < 2) {
      return;
    }
    List<SectionModel> newSections = [];

    for (var i = 0; i < state.sections.length; i++) {
      if (i == index) {
        continue;
      }
      newSections.add(state.sections[i]);
    }
    state = state.copyWith(sections: newSections);
  }

  void toggleShowCompletedTask() {
    state = state.copyWith(showCompletedTask: !state.showCompletedTask);
  }

  void markAsComplete(TaskModel task) {
    if (task.completed) {
      print("Task is Already completed! ----- ${task.taskName}");
      return;
    }
    if (state.selectedIndex == 0 || task.starred) {
      // task is starred and task is task is in star section
      // 1. first we have to remove it from the star section
      // 2. second we have to move it to the parentSection completed tasks not in the tasks

      final parentIndex = state.sections.indexWhere(
        (t) => t.sectionId == task.parentSectionId,
      );
      if (parentIndex == -1) {
        debugPrint("No Parent --- ${task.taskName}");
        return;
      }
      //removing it from star sections task and also making the completetasks empty, just in case
      final starSection = state.sections[0];
      final updatedStarSection = starSection.copyWith(
        tasks: starSection.tasks.where((t) => t.taskId != task.taskId).toList(),
        completedTask: [],
      );
      //removing the task from parentSections task and adding it to the completeTasks
      final parentSection = state.sections[parentIndex];
      final updatedParentSection = parentSection.copyWith(
        tasks: parentSection.tasks
            .where((t) => t.taskId != task.taskId)
            .toList(),
        completedTask: [
          ...parentSection.completedTask,
          task.copyWith(completed: true),
        ],
      );
      //now have to update the state
      final newSectionList = [...state.sections];
      newSectionList[0] = updatedStarSection;
      newSectionList[parentIndex] = updatedParentSection;
      state = state.copyWith(sections: newSectionList);
    } else {
      final parentIndex = state.sections.indexWhere(
        (s) => s.sectionId == task.parentSectionId,
      );
      if (parentIndex == -1) {
        debugPrint("No Parent --- ${task.taskName}");
        return;
      }
      final parentSection = state.sections[parentIndex];
      final updatedParentSection = parentSection.copyWith(
        tasks: parentSection.tasks
            .where((t) => t.taskId != task.taskId)
            .toList(),
        completedTask: [
          ...parentSection.completedTask,
          task.copyWith(completed: true),
        ],
      );
      final newSectionList = [...state.sections];
      newSectionList[parentIndex] = updatedParentSection;
      state = state.copyWith(sections: newSectionList);
    }
  }

  void markAsInComplete(TaskModel task) {
    if (task.completed == false) {
      print("Task is already Incomplete ---- ${task.taskName}");
      return;
    }
    //if the task is starred then when mark As Incomplete I want to add the task in the star section as Incomplete too
    if (task.starred) {
      final starSection = state.sections[0];
      final updatedStarSection = starSection.copyWith(
        tasks: [...starSection.tasks, task.copyWith(completed: false)],
      );
      _updateSection(updatedStarSection);
    }
    //remove from parentSections.completeTasks
    //add to parentSection.tasks with task.complete = false
    final parentSection = state.sections[state.selectedIndex];
    if (task.parentSectionId != parentSection.sectionId) {
      print(
        "Mismatch of tasks in markAsInComplete function ---- ${task.taskName}",
      );
    }

    final updatedSection = parentSection.copyWith(
      tasks: [...parentSection.tasks, task.copyWith(completed: false)],
      completedTask: parentSection.completedTask
          .where((t) => t.taskId != task.taskId)
          .toList(),
    );
    _updateSection(updatedSection);
  }

  //add Section
  void addSection(String name) {
    state = state.copyWith(
      sections: [
        ...state.sections,
        SectionModel(sectionName: name),
      ],
    );
  }

  //add Task to the selection section
  void addTask({required String taskName, bool star = false}) {
    //If the user trying to create task from star section I want to create the task as parentSection of 1 and 0 both
    if (state.selectedIndex == 0) {
      final selectedSection = state.sections[1];
      final newTask = TaskModel(
        taskName: taskName,
        parentSectionId: selectedSection.sectionId,
        starred: state.selectedIndex == 0,
      );
      final updatedSection = selectedSection.copyWith(
        tasks: [...selectedSection.tasks, newTask],
      );
      final updateStarSection = state.sections[0].copyWith(
        tasks: [...state.sections[0].tasks, newTask.copyWith()],
      );
      final newSectionList = [...state.sections];
      newSectionList[0] = updateStarSection;
      newSectionList[1] = updatedSection;
      state = state.copyWith(sections: newSectionList);
    } else if (state.selectedIndex != 0 && star == true) {
      final parentSectionIndex = state.sections.indexWhere(
        (s) => s.sectionId == state.sections[state.selectedIndex].sectionId,
      );
      if (parentSectionIndex == -1) {
        print("Can not find the parentSection");
        return;
      }
      final parentSection = state.sections[parentSectionIndex];
      final newTask = TaskModel(
        taskName: taskName,
        parentSectionId: parentSection.sectionId,
        starred: star,
      );
      final updatedStarSection = state.sections[0].copyWith(
        tasks: [...state.sections[0].tasks, newTask],
      );
      final updatedParentSection = state.sections[parentSectionIndex].copyWith(
        tasks: [
          ...state.sections[parentSectionIndex].tasks,
          newTask.copyWith(),
        ],
      );
      final newList = [...state.sections];
      newList[0] = updatedStarSection;
      newList[parentSectionIndex] = updatedParentSection;
      state = state.copyWith(sections: newList);
    } else {
      final selectedSection = state.sections[state.selectedIndex];
      final updatedSection = selectedSection.copyWith(
        tasks: [
          ...selectedSection.tasks,
          TaskModel(
            taskName: taskName,
            parentSectionId: selectedSection.sectionId,
          ),
        ],
      );
      _updateSection(updatedSection);
    }
  }

  //Helper Function
  void _updateSection(SectionModel updatedSection) {
    print(
      '--------Updated section: ${updatedSection.sectionName}, '
      'tasks: ${updatedSection.tasks.length}, '
      'completed: ${updatedSection.completedTask.length}',
    );

    final newList = [
      for (final section in state.sections)
        section.sectionId == updatedSection.sectionId
            ? updatedSection
            : section,
    ];
    print(
      '-------Updated section: ${updatedSection.sectionName}, '
      'tasks: ${updatedSection.tasks.length}, '
      'completed: ${updatedSection.completedTask.length}',
    );

    state = state.copyWith(sections: newList);
  }

  void printAllTasks(int index) {
    for (final task in state.sections[index].tasks) {
      print("Tasks ----- ${task.taskName}");
    }
  }

  void _replaceSectionAt(int index, SectionModel section) {
    final newList = [...state.sections];
    newList[index] = section;
    state = state.copyWith(sections: newList);
  }
}

final taskManagerProvider = StateNotifierProvider<TaskManager, TaskStateModel>((
  ref,
) {
  return TaskManager();
});
