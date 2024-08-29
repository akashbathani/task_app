import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../model/task_schema.dart';

class TaskRepository {
  final SharedPreferences sharedPreferences;
  static const String taskListKey = 'task_list';

  TaskRepository({required this.sharedPreferences});

  Future<List<Task>> getTasks() async {
    final taskListJson = sharedPreferences.getString(taskListKey);
    if (taskListJson != null) {
      final List<dynamic> taskListMap = json.decode(taskListJson);
      return taskListMap.map((task) => Task.fromJson(task)).toList();
    }
    return [];
  }

  Future<void> addTask(Task task) async {
    final tasks = await getTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  Future<void> updateTask(Task updatedTask) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
      await saveTasks(tasks);
    }
  }

  Future<void> deleteTask(String taskId) async {
    final tasks = await getTasks();
    tasks.removeWhere((task) => task.id == taskId);
    await saveTasks(tasks);
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final taskListJson = json.encode(tasks.map((task) => task.toJson()).toList());
    await sharedPreferences.setString(taskListKey, taskListJson);
  }
}
