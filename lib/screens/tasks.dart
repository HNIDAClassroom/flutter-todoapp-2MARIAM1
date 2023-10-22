import 'package:flutter/material.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/tasks_list.dart';
import 'package:todo_list_app/widgets/new_task.dart';
import 'package:todo_list_app/widgets/side_bar.dart';
import 'dart:convert';
import 'dart:io';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() {
    return _TasksState();
  }
}

class _TasksState extends State<Tasks> {
  final List<Task> tasks = [];
  void _openAddTaskOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => NewTask(addTask), // Pass a function to add tasks
    );
  }

  // Function to add a task to the list
  void addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
    saveTasks();
  }

  @override
  void initState() {
    super.initState();
    loadTasks(); // Load tasks when the app starts
  }

  // Load tasks from the JSON file
  Future<void> loadTasks() async {
    try {
      final jsonString = await File('assets/tasks_data.json').readAsString();
      final List<dynamic> jsonList = json.decode(jsonString);
      setState(() {
        tasks.clear();
        tasks.addAll(jsonList.map((taskJson) => Task.fromJson(taskJson)));
      });
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  // Save tasks to the JSON file
  Future<void> saveTasks() async {
    final List<Map<String, dynamic>> taskList =
        tasks.map((task) => task.toJson()).toList();
    final jsonString = json.encode(taskList);
    await File('assets/tasks_data.json').writeAsString(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomSideBar(),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(20),
            child: Builder(builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu_rounded),
                color: Colors.black,
              );
            }),
          ),
          Column(
            children: [
              SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 100,
                width: double.infinity,
                child: Center(
                  child: Text(
                    "My to-do List",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Expanded(child: TasksList(tasks: tasks))
            ],
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: _openAddTaskOverlay,
              child: const Icon(Icons.add,
                  size: 30, color: Color.fromARGB(255, 77, 8, 90)),
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(), padding: EdgeInsets.all(15)),
            ),
          ),
        ],
      ),
    );
  }
}
