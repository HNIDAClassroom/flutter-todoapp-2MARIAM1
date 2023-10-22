import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_app/models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem(this.task, {super.key});
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
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    task.description,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            task.category.name,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "${DateFormat('HH:mm').format(task.date)}  ${DateFormat.yMMMd().format(task.date)}",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 12),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          )),
    );
  }
}
