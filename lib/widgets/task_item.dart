import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/services/firestore.dart';
import 'dart:ui' as ui;

class TaskItem extends StatelessWidget {
  final Task task;

  TaskItem(this.task, {super.key});

  final _firestoreService = FirestoreService();

  void _deleteTask() {
    _firestoreService.deleteTask(task.reference!);
  }

  void _toggleTaskCompletion(DocumentReference reference, bool isCompleted) {
    _firestoreService.updateTaskCompletion(reference, isCompleted);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(task.title),
                content: Text(task.description),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text('X'),
                  ),
                ],
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(30.0), // Customize the radius as needed
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'modify') {
                        _showModifyTask(context);
                      } else if (value == 'delete') {
                        _deleteTask();
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return ['modify', 'delete'].map((String choice) {
                        return PopupMenuItem(
                          value: choice,
                          child: Text(choice == 'modify'
                              ? 'Modify Task'
                              : 'Delete Task'),
                        );
                      }).toList();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: InkWell(
                          onTap: () {
                            _toggleTaskCompletion(
                                task.reference!, !task.isCompleted!);
                          },
                          child: task.isCompleted!
                              ? Icon(Icons.check_circle,
                                  color: Colors.green,
                                  size:
                                      30) // Checkmark icon for completed tasks
                              : Icon(Icons.radio_button_unchecked,
                                  color: Colors.grey,
                                  size: 30), // Circle icon for incomplete tasks
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(task.title,
                                softWrap: true,
                                style: TextStyle(
                                  color: task.isCompleted == true
                                      ? Colors.grey
                                      : Colors.black,
                                  decoration: task.isCompleted == true
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  decorationColor: task.isCompleted == true
                                      ? Colors.grey[500]
                                      : null,
                                  decorationThickness:
                                      task.isCompleted == true ? 2 : null,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              task.description,
                              style: TextStyle(
                                color: task.isCompleted == true
                                    ? Colors.grey
                                    : Colors.black54,
                                decoration: task.isCompleted == true
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                decorationColor: task.isCompleted == true
                                    ? Colors.grey[500]
                                    : null,
                                decorationThickness:
                                    task.isCompleted == true ? 2 : null,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star_border_rounded,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  task.category.name,
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.calendar_month_rounded,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${DateFormat('HH:mm').format(task.date)} \n ${DateFormat.yMMMd().format(task.date)}",
                                  softWrap: true,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  _showModifyTask(BuildContext context) {
    String modifiedTitle = task.title;
    String modifiedDescription = task.description;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Modify Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Task Title'),
              onChanged: (value) {
                modifiedTitle = value;
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Task Description',
              ),
              onChanged: (value) {
                modifiedDescription = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Perform the task modification
              if (modifiedTitle.isNotEmpty && modifiedDescription.isNotEmpty) {
                _firestoreService.updateTask(
                  task.reference!,
                  modifiedTitle,
                  modifiedDescription,
                );
                Navigator.pop(ctx);
              }
            },
            child: Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
