import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/model_class/task_model.dart';

class SharedPreferenceHandler {
  late SharedPreferences preferences;

  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future<void> saveTask(List<TaskModel> taskList) async {
    await init();
    final String taskString =
        jsonEncode(taskList.map((task) => task.toJson()).toList());
    await preferences.setString("task", taskString);
  }

  Future<List<TaskModel>> getTasks() async {
    final String? taskString = preferences.getString("task");
    if (taskString == null) {
      return [];
    }
    final List<dynamic> jsonList = jsonDecode(taskString);
    return jsonList.map((json) => TaskModel.fromJson(json)).toList();
  }
}
