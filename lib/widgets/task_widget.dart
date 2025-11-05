import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_hustle_hub/models/task_model.dart';
import 'package:to_do_hustle_hub/providers/task_manager.dart';

class TaskWidget extends ConsumerWidget {
  final TaskModel task;
  const TaskWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskManager = ref.watch(taskManagerProvider.notifier);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        enableFeedback: true,

        onLongPress: () {
          print("Pressed Long Press -----------------");
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Delete Task ?"),
                content: Text(
                  "Are you sure you want to delete this task : \"${task.taskName}\" ?",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel", style: TextStyle(color: Colors.blue)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      taskManager.deletTask(task);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "The task: \"${task.taskName}\" is deleted",
                          ),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Text("Delete", style: TextStyle(color: Colors.red)),
                  ),
                ],
              );
            },
          );
        },
        child: SizedBox(
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  if (task.completed) {
                    taskManager.markAsInComplete(task);
                  } else {
                    taskManager.markAsComplete(task);
                  }
                },
                icon: task.completed
                    ? Icon(Icons.check, color: Colors.green)
                    : Icon(Icons.circle_outlined),
              ),
              Text(task.taskName),
              Spacer(),
              IconButton(
                onPressed: () {
                  if (task.starred) {
                    taskManager.markAsUnstar(task);
                  } else {
                    taskManager.markAsStar(task);
                  }
                },
                icon: Icon(
                  task.starred ? Icons.star : Icons.star_border,
                  color: task.starred ? Colors.amber : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
