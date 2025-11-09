import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_hustle_hub/models/task_model.dart';
import 'package:to_do_hustle_hub/providers/task_manager.dart';
import 'package:to_do_hustle_hub/providers/text_controller_provider.dart';

class TaskDetailScreen extends ConsumerWidget {
  final TaskModel task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskManagerProvider);
    final taskManager = ref.watch(taskManagerProvider.notifier);

    final allCompleted = taskState.sections.expand((s) => s.completedTasks);
    final allUncompleted = taskState.sections.expand((s) => s.tasks);

    TaskModel? updatedTask;
    if (task.completed) {
      updatedTask = allCompleted.firstWhere(
        (t) => t.taskId == task.taskId,
        orElse: () => task, // fallback to the passed-in task
      );
    } else {
      updatedTask = allUncompleted.firstWhere(
        (t) => t.taskId == task.taskId,
        orElse: () => task,
      );
    }

    final taskNameController = ref.watch(
      taskNameControllerInDeatilScreen(task.taskName),
    );
    final taskDescriptionController = ref.watch(
      taskNameControllerInDeatilScreen(task.taskDescription ?? " "),
    );

    return Scaffold(
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlueAccent,
        ),
        onPressed: () {
          if (task.completed) {
            Navigator.pop(context);
            taskManager.markAsInComplete(task);
          } else {
            Navigator.pop(context);
            taskManager.markAsComplete(task);
          }
        },
        child: Text(
          task.completed ? "Mark as InCompleted" : "Mark As Completed",
          style: TextStyle(color: Colors.black),
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              if (updatedTask!.starred) {
                taskManager.markAsUnstar(updatedTask);
              } else {
                taskManager.markAsStar(updatedTask);
              }
            },
            icon: Icon(
              updatedTask.starred ? Icons.star : Icons.star_outline,
              color: updatedTask.starred ? Colors.amber : Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Delete Task?"),
                    content: Text(
                      "Are you sure you want to delete this task ?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          taskManager.deleteTask(task);
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      height: 300,
                      child: Consumer(
                        builder: (context, ref, child) {
                          final taskStateS = ref.watch(taskManagerProvider);
                          final taskManagerS = ref.watch(
                            taskManagerProvider.notifier,
                          );
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Move tasks to"),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: taskStateS.sections.length - 1,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 12,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          taskManagerS.moveTaskToAnotherSection(
                                            task,
                                            index + 1,
                                            taskStateS.selectedIndex,
                                          );
                                          Navigator.pop(context);
                                        },
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 50,
                                              child:
                                                  taskStateS.selectedIndex ==
                                                      index + 1
                                                  ? Icon(
                                                      Icons.check,
                                                      color: Colors.green,
                                                    )
                                                  : Icon(
                                                      Icons.label_important,
                                                      color: Colors.grey,
                                                    ),
                                            ),
                                            SizedBox(width: 15),
                                            Text(
                                              taskStateS
                                                  .sections[index + 1]
                                                  .sectionName,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    taskStateS.selectedIndex ==
                                                        index + 1
                                                    ? Colors.white
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                );
              },
              child: Row(
                children: [
                  Text(
                    taskState.sections[taskState.selectedIndex].sectionName,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 119, 212, 254),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: const Color.fromARGB(255, 119, 212, 254),
                    size: 25,
                  ),
                ],
              ),
            ),
            TextField(
              controller: taskNameController,

              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
              // autofocus: true,
              cursorColor: Colors.lightBlueAccent,
              onTapOutside: (event) {
                if (task.taskName != taskNameController.text.trim()) {
                  taskManager.editTaskName(
                    task,
                    taskNameController.text.trim(),
                  );
                }
                FocusScope.of(context).unfocus();
              },
            ),
            Row(
              children: [
                Icon(Icons.notes),
                Expanded(
                  child: TextField(
                    controller: taskDescriptionController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "add details...",
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    // autofocus: true,
                    cursorColor: Colors.lightBlueAccent,
                    onTapOutside: (event) {
                      if (task.taskDescription !=
                          taskDescriptionController.text.trim()) {
                        taskManager.editTaskDescription(
                          task,
                          taskDescriptionController.text.trim(),
                        );
                      }
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
