import 'package:flutter/material.dart';
import 'package:to_do_hustle_hub/screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(darkTheme: ThemeData.dark(),home: HomeScreen(),);
  }
}
