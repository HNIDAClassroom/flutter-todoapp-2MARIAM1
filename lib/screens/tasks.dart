import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/widgets/tasks_list.dart';
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
  int selectedSegmentIndex = 0;
  final List<Task> tasks = [];
  void _openAddTaskOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) =>
          const NewTask(), //NewTask(addTask), // Pass a function to add tasks
    );
  }

  // Function to add a task to the list
  // void addTask(Task task) {
  //   setState(() {
  //     tasks.add(task);
  //   });
  //   saveTasks();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   loadTasks(); // Load tasks when the app starts
  // }

  // Load tasks from the JSON file
  // Future<void> loadTasks() async {
  //   try {
  //     final jsonString = await rootBundle.loadString('assets/tasks_data.json');

  //     final List<dynamic> jsonList = json.decode(jsonString);
  //     setState(() {
  //       tasks.clear();
  //       tasks.addAll(jsonList.map((taskJson) => Task.fromJson(taskJson)));
  //     });
  //   } catch (e) {
  //     print('Error loading tasks: $e');
  //   }
  // }

  // Save tasks to the JSON file
  // Future<void> saveTasks() async {
  //   final List<Map<String, dynamic>> taskList =
  //       tasks.map((task) => task.toJson()).toList();
  //   final jsonString = json.encode(taskList);

  //   final directory = await getApplicationDocumentsDirectory();
  //   print("directory path : ${directory.path}");
  //   final myfile = File('${directory.path}/tasks_data.json');

  //   await myfile.writeAsString(jsonString);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomSideBar(),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(20),
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
              const SizedBox(
                height: 30,
              ),
              const SizedBox(
                height: 180,
                width: double.infinity,
                child: Center(
                  child: Text(
                    "My to-do List",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              _buildToggleTasks(),
              Expanded(
                  child: TasksList(selectedSegmentIndex: selectedSegmentIndex))
            ],
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: _openAddTaskOverlay,
              style: ElevatedButton.styleFrom(
                  elevation: 5,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(15)),
              child: const Icon(Icons.add, size: 30, color: Colors.deepPurple),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTasks() {
    return Container(
      color: Colors.white,
      child: CupertinoSegmentedControl<int>(
        selectedColor: Colors.transparent,
        borderColor: Colors.transparent,
        unselectedColor: Colors.transparent,
        padding: EdgeInsets.all(5.0),
        children: {
          0: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: selectedSegmentIndex == 0
                  ? Colors.deepPurpleAccent.withOpacity(0.6)
                  : Colors.transparent,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.list_rounded,
                  color:
                      selectedSegmentIndex == 0 ? Colors.white : Colors.black,
                ),
                SizedBox(width: 8),
                Text(
                  'All tasks',
                  style: TextStyle(
                    color:
                        selectedSegmentIndex == 0 ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          1: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: selectedSegmentIndex == 1
                  ? Colors.deepPurpleAccent.withOpacity(0.6)
                  : Colors.transparent,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check,
                  color:
                      selectedSegmentIndex == 1 ? Colors.white : Colors.black,
                ),
                SizedBox(width: 8),
                Text(
                  'Completed',
                  style: TextStyle(
                    color:
                        selectedSegmentIndex == 1 ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )
        },
        onValueChanged: (index) {
          setState(() {
            selectedSegmentIndex = index;
          });
        },
        groupValue: selectedSegmentIndex,
      ),
    );
  }
}
