import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter/models/task_model.dart';
import 'package:test_flutter/providers/task_provider.dart';
import 'package:test_flutter/widgets/custom_checkbox_w.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todo List',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          _displayAddTaskDialog(context);
        },
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          List<Task> filteredTasks;
          if (_filter == 'completed') {
            filteredTasks =
                taskProvider.tasks.where((task) => task.isCompleted).toList();
          } else if (_filter == 'incomplete') {
            filteredTasks =
                taskProvider.tasks.where((task) => !task.isCompleted).toList();
          } else {
            filteredTasks = taskProvider.tasks;
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_filter == 'incomplete' || _filter == 'all')
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                'Incomplete Tasks (${filteredTasks.where((task) => !task.isCompleted).length})',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 8.0),
                        if (_filter == 'completed' || _filter == 'all')
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                'Complete Tasks (${filteredTasks.where((task) => task.isCompleted).length})',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                const Divider(),
                const Text('Filter by:'),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: DropdownButton<String>(
                    value: _filter,
                    onChanged: (String? newValue) {
                      setState(() {
                        _filter = newValue!;
                      });
                    },
                    items: <String>['all', 'completed', 'incomplete']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.toUpperCase()),
                      );
                    }).toList(),
                    underline: const SizedBox(), // Remove the default underline
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                        ),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: filteredTasks[index].isCompleted
                              ? Colors.green
                              : Colors.blue,
                          child: GestureDetector(
                            onTap: () {
                              taskProvider.toggleTaskCompletion(index);
                            },
                            child: ListTile(
                              title: Text(
                                filteredTasks[index].title,
                                style: TextStyle(
                                  decoration: filteredTasks[index].isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              leading: CustomCheckbox(
                                value: filteredTasks[index].isCompleted,
                                onChanged: (bool? value) {
                                  taskProvider.toggleTaskCompletion(index);
                                },
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Are you sure want delete this todo?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Yes, delete'),
                                            onPressed: () {
                                              taskProvider.removeTask(index);
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _displayAddTaskDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    String? newTaskTitle;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new task'),
          content: Form(
            key: formKey,
            child: TextFormField(
              onChanged: (value) {
                newTaskTitle = value;
              },
              decoration: const InputDecoration(hintText: "Task title"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a task title';
                }
                return null;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (newTaskTitle != null && newTaskTitle!.isNotEmpty) {
                    Provider.of<TaskProvider>(context, listen: false)
                        .addTask(newTaskTitle!);
                  }
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
