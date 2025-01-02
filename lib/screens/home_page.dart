import 'package:flutter/material.dart';
import 'package:task_manager/model_class/task_model.dart';
import 'package:task_manager/screens/add_task_screen.dart';

import '../utils/locator.dart';
import '../utils/shared_preference_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TaskModel>? taskList = [];
  bool taskLoading = true;
  final preference = getIt<SharedPreferenceHandler>();

  @override
  void initState() {
    super.initState();
    getTask();
  }

  void getTask() async {
    setState(() {
      taskLoading = true;
    });
    taskList = await preference.getTasks();
    setState(() {
      taskLoading = false;
    });
  }

  void addTaskScreen() async {
    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AddTaskDialog(),
    );

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task added successfully')),
      );
    }
    getTask();
  }

  deleteTask(String id) async {
    taskList!.removeWhere((ele) => ele.id == id);
    await preference.saveTask(taskList!);
    getTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                addTaskScreen();
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: !taskLoading
          ? taskList!.isEmpty
              ? const Center(
                  child: Text("There are no tasks. Please add the task"))
              : ListView.builder(
                  itemCount: taskList!.length,
                  itemBuilder: (context, index) {
                    TaskModel task = taskList![index];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${task.title}"),
                                const SizedBox(height: 10),
                                Text("${task.description}"),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          IconButton(
                              onPressed: () {
                                deleteTask(task.id!);
                              },
                              icon: const Icon(Icons.delete))
                        ],
                      ),
                    );
                  })
          : const CircularProgressIndicator(),
    );
  }
}
