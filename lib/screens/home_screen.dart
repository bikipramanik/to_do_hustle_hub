import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_hustle_hub/widgets/completed_task_widget.dart';
import 'package:to_do_hustle_hub/widgets/horizontal_bar_widget.dart';
import 'package:to_do_hustle_hub/providers/task_manager.dart';
import 'package:to_do_hustle_hub/providers/text_controller_provider.dart';
import 'package:to_do_hustle_hub/widgets/task_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskManagerProvider);
    final taskManager = ref.watch(taskManagerProvider.notifier);

    final selectedSection = taskState.sections[taskState.selectedIndex];
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 43, 43, 43),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 0, 134, 196),
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Consumer(
                  builder: (context, ref, _) {
                    final taskState = ref.watch(taskManagerProvider);
                    final taskManager = ref.watch(taskManagerProvider.notifier);
                    final addTaskNameController = ref.watch(
                      addTaskControllerProvider,
                    );
                    final addDescriptionController = ref.watch(
                      addDescriptionControllerProvider,
                    );

                    return Container(
                      height: taskState.addDescriptionWhileAddingTask
                          ? 150
                          : 100,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 49, 49, 49),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: TextField(
                              controller: addTaskNameController,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: "New Task...",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          if (taskState.addDescriptionWhileAddingTask)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: TextField(
                                controller: addDescriptionController,
                                decoration: InputDecoration(
                                  hintText: "add description...",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: taskManager
                                    .toggleAddDescriptionWhileAddingTask,
                                icon: Icon(
                                  Icons.notes,
                                  color: taskState.addDescriptionWhileAddingTask
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                              ),
                              if (taskState.selectedIndex != 0)
                                IconButton(
                                  onPressed:
                                      taskManager.toggleMarkStarWhileAddingTask,
                                  icon: Icon(
                                    taskState.starWhileAddingTask
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: taskState.starWhileAddingTask
                                        ? Colors.amber
                                        : Colors.grey,
                                  ),
                                ),
                              Spacer(),
                              TextButton(
                                onPressed: () {
                                  if (addTaskNameController.text
                                      .trim()
                                      .isNotEmpty) {
                                    if (taskState.starWhileAddingTask) {
                                      taskManager.addTask(
                                        taskName: addTaskNameController.text
                                            .trim(),
                                        star: true,
                                      );
                                    } else {
                                      taskManager.addTask(
                                        taskName: addTaskNameController.text
                                            .trim(),
                                      );
                                    }
                                    taskManager.printAllTasks(
                                      taskState.selectedIndex,
                                    );
                                    Navigator.pop(context);
                                  } else {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Task Name Needed"),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  "Save",
                                  style: TextStyle(
                                    color: Colors.lightBlueAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ).then((_) {
            ref
                .read(taskManagerProvider.notifier)
                .toggleAddDescriptionWhileAddingTask(reset: true);
            ref
                .read(taskManagerProvider.notifier)
                .toggleMarkStarWhileAddingTask(reset: true);
          });
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        bottom: false,
        // top: false,
        maintainBottomViewPadding: true,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text("Tasks"),
              centerTitle: true,
              floating: false,
              pinned: false,
              snap: false,
              surfaceTintColor: const Color.fromARGB(255, 43, 43, 43),
              backgroundColor: const Color.fromARGB(255, 43, 43, 43),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: HorizontalBarWidget(
                sections: taskState.sections,
                selectedIndex: taskState.selectedIndex,
                changeSection: taskManager.changeScreen,
                deleteSection: taskManager.deleteSection,
              ),
            ),

            selectedSection.tasks.isEmpty
                ? const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "Add tasks to this section",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: EdgeInsets.only(
                      right: 10,
                      left: 10,
                      bottom: selectedSection.completedTasks.isEmpty ? 110 : 10,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            ...List.generate(
                              selectedSection.tasks.length,
                              (index) => TaskWidget(
                                task: selectedSection.tasks[index],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            if (selectedSection.completedTasks.isNotEmpty)
              SliverToBoxAdapter(
                child: Container(
                  height: 10,
                  color: const Color.fromARGB(255, 43, 43, 43),
                ),
              ),

            if (selectedSection.completedTasks.isNotEmpty)
              SliverPadding(
                padding: EdgeInsets.only(
                  right: 10,
                  left: 10,
                  bottom: taskState.showCompletedTask ? 10 : 110,
                ),
                sliver: SliverToBoxAdapter(
                  child: InkWell(
                    onTap: () => taskManager.toggleShowCompletedTask(),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 23, 36, 34),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Row(
                            children: [
                              Text(
                                "Completed Task ",
                                style: TextStyle(
                                  color: taskState.showCompletedTask
                                      ? Colors.lightBlueAccent
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                taskState.showCompletedTask
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: taskState.showCompletedTask
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (selectedSection.completedTasks.isNotEmpty &&
                taskState.showCompletedTask)
              SliverPadding(
                padding: const EdgeInsets.only(
                  right: 10,
                  left: 10,
                  bottom: 110,
                ),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 22, 22, 22),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        ...List.generate(
                          selectedSection.completedTasks.length,
                          (index) => CompletedTaskWidget(
                            task: selectedSection.completedTasks[index],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
