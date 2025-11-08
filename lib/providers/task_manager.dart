import 'package:flutter/material.dart';
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
        completedTasks: [],
      );
      //removing the task from parentSections task and adding it to the completeTasks
      final parentSection = state.sections[parentIndex];
      final updatedParentSection = parentSection.copyWith(
        tasks: parentSection.tasks
            .where((t) => t.taskId != task.taskId)
            .toList(),
        completedTasks: [
          ...parentSection.completedTasks,
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
        completedTasks: [
          ...parentSection.completedTasks,
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
      completedTasks: parentSection.completedTasks
          .where((t) => t.taskId != task.taskId)
          .toList(),
    );
    _updateSection(updatedSection);
  }

  void moveTaskToAnotherSection(
    TaskModel task,
    int newSectionIndex,
    int oldSectionIndex,
  ) {
    //if the task is starred we have to update the tasks parentSection Id from the star section too
    //we have to delete the task from old section
    //have to add the task into new section
    if (task.starred) {
      final oldSection = state.sections[oldSectionIndex];
      final newSection = state.sections[newSectionIndex];
      final starSection = state.sections[0];
      final updatedOldSection = oldSection.copyWith(
        tasks: oldSection.tasks.where((t) => t.taskId != task.taskId).toList(),
      );
      final updatedNewSection = newSection.copyWith(
        tasks: [
          ...newSection.tasks,
          task.copyWith(parentSectionId: newSection.sectionId),
        ],
      );
      final updatedStarSection = starSection.copyWith(
        tasks: starSection.tasks
            .map(
              (t) => t.taskId == task.taskId
                  ? task.copyWith(parentSectionId: newSection.sectionId)
                  : t,
            )
            .toList(),
      );
      final newList = [...state.sections];
      newList[0] = updatedStarSection;
      newList[oldSectionIndex] = updatedOldSection;
      newList[newSectionIndex] = updatedNewSection;
      state = state.copyWith(selectedIndex: newSectionIndex, sections: newList);
      return;
    }

    final oldSection = state.sections[oldSectionIndex];
    final newSection = state.sections[newSectionIndex];
    final updatedOldSection = oldSection.copyWith(
      tasks: oldSection.tasks.where((t) => t.taskId != task.taskId).toList(),
    );
    final updatedNewSection = newSection.copyWith(
      tasks: [
        ...newSection.tasks,
        task.copyWith(parentSectionId: newSection.sectionId),
      ],
    );
    final newList = [...state.sections];

    newList[oldSectionIndex] = updatedOldSection;
    newList[newSectionIndex] = updatedNewSection;
    state = state.copyWith(selectedIndex: newSectionIndex, sections: newList);
  }

  void editTaskName(TaskModel task, String newTaskName) {
    //if the task is starred we have to change the taskName in star section and parentSection
    if (task.starred) {
      final starSection = state.sections[0];
      final updatedStarSection = starSection.copyWith(
        tasks: starSection.tasks
            .map(
              (t) => t.taskId == task.taskId
                  ? t.copyWith(taskName: newTaskName)
                  : t,
            )
            .toList(),
      );
      final parentSectionIndex = state.sections.indexWhere(
        (s) => s.sectionId == task.parentSectionId,
      );
      final parentSection = state.sections[parentSectionIndex];
      final updatedParentSection = parentSection.copyWith(
        tasks: parentSection.tasks
            .map(
              (t) => t.taskId == task.taskId
                  ? t.copyWith(taskName: newTaskName)
                  : t,
            )
            .toList(),
      );
      final newList = [...state.sections];
      newList[0] = updatedStarSection;
      newList[parentSectionIndex] = updatedParentSection;
      state = state.copyWith(sections: newList);
    } else {
      // if the star is completed eather it will be in the completed list or it will be in task list
      if (task.completed) {
        final parentSectionIndex = state.sections.indexWhere(
          (s) => s.sectionId == task.parentSectionId,
        );
        final parentSection = state.sections[parentSectionIndex];
        final updatedParentSection = parentSection.copyWith(
          completedTasks: parentSection.completedTasks
              .map(
                (t) => t.taskId == task.taskId
                    ? t.copyWith(taskName: newTaskName)
                    : t,
              )
              .toList(),
        );
        final newList = [...state.sections];
        newList[parentSectionIndex] = updatedParentSection;
        state = state.copyWith(sections: newList);
      } else {
        final parentSectionIndex = state.sections.indexWhere(
          (s) => s.sectionId == task.parentSectionId,
        );
        final parentSection = state.sections[parentSectionIndex];
        final updatedParentSection = parentSection.copyWith(
          tasks: parentSection.tasks
              .map(
                (t) => t.taskId == task.taskId
                    ? t.copyWith(taskName: newTaskName)
                    : t,
              )
              .toList(),
        );
        final newList = [...state.sections];
        newList[parentSectionIndex] = updatedParentSection;
        state = state.copyWith(sections: newList);
      }
    }
  }

  void deleteTask(TaskModel task) {
    //we have to delete the task from the parentSection for every condition
    //we have to delete the task wheather it is in completed list or wheather it is in task list
    //conditions :
    //condition 1 :  if we want to delete task from star section, we have to delete the task from star sections and parentSection's task list
    //condition 2 : if we want to delete the task which is not in the starred section, there are two sub condition
    //sub condition 1 : if the task is not completed, we have to delete the task from the task section
    //but if it is starred, we have to delete the task from star sections too
    //if not then we have to delete the condition from only the parentSections task list
    //sub condition 2 : if the task is completed we have to delete the task only from the parentSection

    //if the we are deleting task from star section it definetly not completed
    //so here we have remove the task from star section and parentSection's task list only
    if (state.selectedIndex == 0) {
      print("Deleting task --- condition 1 --- deleting from star");
      final parentSectionIndex = state.sections.indexWhere(
        (s) => s.sectionId == task.parentSectionId,
      );
      final starSection = state.sections[0];
      final parentSection = state.sections[parentSectionIndex];

      final updatedParentSection = parentSection.copyWith(
        tasks: parentSection.tasks
            .where((t) => t.taskId != task.taskId)
            .toList(),
      );
      final updatedStarSection = starSection.copyWith(
        tasks: starSection.tasks.where((t) => t.taskId != task.taskId).toList(),
      );

      final newList = [...state.sections];
      newList[0] = updatedStarSection;
      newList[parentSectionIndex] = updatedParentSection;
      state = state.copyWith(sections: newList);
    }
    //if we are not deleting the task from star section then
    else {
      print("Deleteing from non star section");
      //here we are checking if the task is in the completed section or not
      // if the task is completed we have to only remove it from the parentSections completed list
      if (task.completed) {
        print("Deleteing from complete section");

        final parentSectionIndex = state.selectedIndex;
        final parentSection = state.sections[parentSectionIndex];
        final updatedParentSection = parentSection.copyWith(
          completedTasks: parentSection.completedTasks
              .where((ct) => ct.taskId != task.taskId)
              .toList(),
        );
        final newList = [...state.sections];
        newList[parentSectionIndex] = updatedParentSection;
        state = state.copyWith(sections: newList);
      } //if the task is not comepleted we have to check if the task starred or not
      else {
        print("deleting from non InComplete section");
        //if the task is starred we have to remove it from star section and parentSection both
        if (task.starred) {
          print("---- deleting from star section");

          final parentSectionIndex = state.selectedIndex;
          final parentSection = state.sections[parentSectionIndex];
          final starSection = state.sections[0];
          final updatedParentSection = parentSection.copyWith(
            tasks: parentSection.tasks
                .where((t) => t.taskId != task.taskId)
                .toList(),
          );
          final updatedStarSection = starSection.copyWith(
            tasks: starSection.tasks
                .where((t) => t.taskId != task.taskId)
                .toList(),
          );
          final newList = [...state.sections];
          newList[0] = updatedStarSection;
          newList[parentSectionIndex] = updatedParentSection;
          state = state.copyWith(sections: newList);
        } else {
          print("---- deleting from Un star section");
          final parentSectionIndex = state.selectedIndex;
          final parentSection = state.sections[parentSectionIndex];
          final updatedParentSection = parentSection.copyWith(
            tasks: parentSection.tasks
                .where((t) => t.taskId != task.taskId)
                .toList(),
          );
          final newList = [...state.sections];
          newList[parentSectionIndex] = updatedParentSection;
          state = state.copyWith(sections: newList);
        }
      }
    }
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
  void addTask({
    required String taskName,
    bool star = false,
    String? description,
  }) {
    //If the user trying to create task from star section I want to create the task as parentSection of 1 and 0 both
    if (state.selectedIndex == 0) {
      print(
        "Adding task condition 1 --------\ncurrent section -- ${state.selectedIndex}---adding task\nadding task in ${state.sections[1].sectionName}\nTask Name -----$taskName---$star",
      );
      final selectedSection = state.sections[1];
      final newTask = TaskModel(
        taskName: taskName,
        taskDescription: description,
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
      print(
        "Adding task condition 2 --------\ncurrent section -- ${state.selectedIndex}---adding task\nadding task in ${parentSection.sectionName}\nTask Name -----$taskName---$star",
      );
      final newTask = TaskModel(
        taskName: taskName,
        taskDescription: description,
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
      final parentSectionIndex = state.sections.indexWhere(
        (s) => s.sectionId == state.sections[state.selectedIndex].sectionId,
      );
      if (parentSectionIndex == -1) {
        print("Can not find the parentSection");
        return;
      }
      final selectedSection = state.sections[parentSectionIndex];
      print(
        "Adding task codition 3--------\ncurrent section -- ${state.selectedIndex}---adding task\nadding task in ${selectedSection.sectionName}\nTask Name -----$taskName---$star",
      );
      final updatedSection = selectedSection.copyWith(
        tasks: [
          ...selectedSection.tasks,
          TaskModel(
            taskName: taskName,
            taskDescription: description,
            parentSectionId: selectedSection.sectionId,
          ),
        ],
      );
      _updateSection(updatedSection);
    }
  }

  void markAsStar(TaskModel task) {
    print("Running markAsStar --- ${task.taskName}");
    if (task.starred) {
      print("Task is already starred --- ${task.taskName}");
      return;
    }
    //have to add in starSections tasks with starred = true;
    // make the task starred = true, in the parentSection;
    final parentSection = state.sections[state.selectedIndex];
    final starSection = state.sections[0];
    final updatedStarSection = starSection.copyWith(
      tasks: [...starSection.tasks, task.copyWith(starred: true)],
    );
    final updatedParentSectionTaskList = parentSection.tasks
        .map((t) => t.taskId == task.taskId ? t.copyWith(starred: true) : t)
        .toList();
    final updatedParentSection = parentSection.copyWith(
      tasks: updatedParentSectionTaskList,
    );
    final newList = [...state.sections];
    newList[0] = updatedStarSection;
    newList[state.selectedIndex] = updatedParentSection;
    state = state.copyWith(sections: newList);
  }

  void markAsUnstar(TaskModel task) {
    print("Running markAsUnStar --- ${task.taskName}");
    if (!task.starred) {
      print("Task is already un Star --- ${task.taskName}");
      return;
    }
    //we have to find the parentSection
    //we have tro remove the task from star section
    //we have to make the task at ParentSection starred = false with copyWith
    final parentSectionIndex = state.sections.indexWhere(
      (s) => s.sectionId == task.parentSectionId,
    );
    if (parentSectionIndex == -1) {
      print("MakuAsUnstar ---- parentSection not found ---${task.taskName}");
      return;
    }
    final parentSection = state.sections[parentSectionIndex];
    final starSection = state.sections[0];
    final updatedStarSection = starSection.copyWith(
      tasks: starSection.tasks.where((t) => t.taskId != task.taskId).toList(),
    );
    final updatedParentSectionTaskList = parentSection.tasks
        .map((t) => task.taskId == t.taskId ? t.copyWith(starred: false) : t)
        .toList();
    final updatedParentSection = parentSection.copyWith(
      tasks: updatedParentSectionTaskList,
    );

    final newList = [...state.sections];
    newList[0] = updatedStarSection;
    newList[parentSectionIndex] = updatedParentSection;
    state = state.copyWith(sections: newList);
  }

  //Helper Function
  void _updateSection(SectionModel updatedSection) {
    print(
      '--------Updated section: ${updatedSection.sectionName}, '
      'tasks: ${updatedSection.tasks.length}, '
      'completed: ${updatedSection.completedTasks.length}',
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
      'completed: ${updatedSection.completedTasks.length}',
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
