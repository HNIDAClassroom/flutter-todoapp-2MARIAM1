import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/services/firestore.dart';
import 'package:todo_list_app/widgets/task_item.dart';

class TasksList extends StatelessWidget {
  final int selectedSegmentIndex;
  TasksList({
    required this.selectedSegmentIndex,
    super.key,
  });

  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Text('No tasks available.');
          } else {
            final taskLists = snapshot.data!.docs;
            List<Task> taskItems = [];

            for (int index = 0; index < taskLists.length; index++) {
              DocumentSnapshot document = taskLists[index];
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              DocumentReference taskReference = document.reference;

              String title = data['taskTitle'];
              String description = data['taskDesc'];
              DateTime date = DateTime.parse(data['taskDate']);
              String categoryString = data['taskCategory'];
              bool iscompleted = data['isCompleted'];
              Category category;
              switch (categoryString) {
                case 'Category.personal':
                  category = Category.personal;
                  break;
                case 'Category.work':
                  category = Category.work;
                  break;
                case 'Category.shopping':
                  category = Category.shopping;
                  break;
                default:
                  category = Category.other;
              }
              Task task = Task(
                  title: title,
                  description: description,
                  date: date,
                  category: category,
                  reference: taskReference,
                  isCompleted: iscompleted);
              taskItems.add(task);
            }
            taskItems.sort((b, a) => a.date.compareTo(b.date));
            List<Task> displayedTasks = selectedSegmentIndex == 0
                ? taskItems
                : taskItems
                    .where((task) => task.isCompleted!)
                    .toList(); // Show completed tasks when selectedSegmentIndex is 1
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.deepPurpleAccent.withOpacity(0.4),
                    const Color.fromRGBO(224, 64, 251, 1).withOpacity(0.5)
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft:
                      Radius.circular(30.0), // Customize the radius as needed
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: ListView.builder(
                itemCount: displayedTasks.length,
                itemBuilder: (ctx, index) => TaskItem(displayedTasks[index]),
              ),
            );
          }
        });
  }
}
