import 'package:flutter/material.dart';
import 'package:task_manager/screens/home_page.dart';
import 'package:task_manager/utils/locator.dart';
import 'package:task_manager/utils/shared_preference_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  locator();
  await getIt<SharedPreferenceHandler>().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
