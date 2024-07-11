// lib/providers/task_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:test_flutter/models/task_model.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  TaskProvider() {
    _loadTasksFromPrefs();
  }

  void addTask(String title) {
    _tasks.add(Task(title: title));
    notifyListeners();
    _saveTasksToPrefs();
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
    _saveTasksToPrefs();
  }

  void toggleTaskCompletion(int index) {
    _tasks[index].isCompleted = !_tasks[index].isCompleted;
    notifyListeners();
    _saveTasksToPrefs();
  }

  void _loadTasksFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      List<dynamic> tasksList = json.decode(tasksJson);
      _tasks = tasksList.map((taskJson) => Task.fromJson(taskJson)).toList();
    }
    notifyListeners();
  }

  void _saveTasksToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tasksJson =
        json.encode(_tasks.map((task) => task.toJson()).toList());
    prefs.setString('tasks', tasksJson);
  }
}
