import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_hustle_hub/models/section_model.dart';
import 'package:to_do_hustle_hub/models/task_model.dart';
import 'package:to_do_hustle_hub/models/task_state_model.dart';
import 'package:to_do_hustle_hub/providers/task_manager.dart';
import 'package:to_do_hustle_hub/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(SectionModelAdapter());
  Hive.registerAdapter(TaskStateModelAdapter());
  await Hive.openBox<TaskStateModel>('taskStateBox');

  // Initialize TaskManager with Hive data
  final taskManager = await TaskManager.initialize();

  runApp(
    ProviderScope(
      overrides: [taskManagerProvider.overrideWith((ref) => taskManager)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(darkTheme: ThemeData.dark(), home: HomeScreen());
  }
}
