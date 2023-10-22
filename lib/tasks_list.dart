import 'package:flutter/material.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/widgets/task_item.dart';

class TasksList extends StatelessWidget {
  const TasksList({
    super.key,
    required this.tasks,
  });

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0), // Customize the radius as needed
          topRight: Radius.circular(30.0),
        ),
      ),
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (ctx, index) => TaskItem(tasks[index]),
      ),
    );
  }
}
