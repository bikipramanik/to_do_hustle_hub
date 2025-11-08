import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_hustle_hub/models/task_model.dart';
import 'package:to_do_hustle_hub/providers/task_manager.dart';
import 'package:to_do_hustle_hub/screens/task_detail_screen.dart';

class CompletedTaskWidget extends ConsumerWidget {
  final TaskModel task;

  const CompletedTaskWidget({super.key, required this.task});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskManager = ref.watch(taskManagerProvider.notifier);
    return Material(
      color: const Color.fromARGB(255, 22, 22, 22),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
        ),
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
                      taskManager.deleteTask(task);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("\"${task.taskName}\" is deleted"),
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
                  taskManager.markAsInComplete(task);
                },
                icon: Icon(Icons.check, color: Colors.green),
              ),
              Text(
                task.taskName,
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
