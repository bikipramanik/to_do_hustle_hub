import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_hustle_hub/models/task_model.dart';
import 'package:to_do_hustle_hub/providers/task_manager.dart';

class CompletedTaskWidget extends ConsumerWidget {
  final TaskModel task;

  const CompletedTaskWidget({super.key, required this.task});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskManager = ref.watch(taskManagerProvider.notifier);
    return Container(
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
    );
  }
}
