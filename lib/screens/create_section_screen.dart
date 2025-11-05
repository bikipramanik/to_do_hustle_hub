import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_hustle_hub/providers/text_controller_provider.dart';
import 'package:to_do_hustle_hub/providers/task_manager.dart';

class CreateSectionScreen extends ConsumerWidget {
  const CreateSectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionNameController = ref.watch(sectionNameControllerProvider);
    final taskManager = ref.read(taskManagerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Section"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              final sectionName = sectionNameController.text.trim();
              if (sectionName.isNotEmpty) {
                taskManager.addSection(sectionName);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please enter a section name")),
                );
              }
            },
            child: const Text(
              "Save",
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextField(
          autofocus: true,
          controller: sectionNameController,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          cursorHeight: 25,
          cursorColor: Colors.blueAccent,
          style: const TextStyle(fontSize: 18),
          decoration: InputDecoration(
            hintText: "Enter List Name...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
        ),
      ),
    );
  }
}
