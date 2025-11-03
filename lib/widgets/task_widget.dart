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
    return Container(
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
            onPressed: () {},
            icon: Icon(
              task.starred ? Icons.star : Icons.star_border,
              color: task.starred ? Colors.amber : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
