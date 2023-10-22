import 'package:flutter/material.dart';
import 'package:todo_list_app/models/task.dart';

class NewTask extends StatefulWidget {
  final Function(Task) addTask;

  const NewTask(this.addTask, {Key? key}) : super(key: key);
  @override
  State<NewTask> createState() {
    return _NewTaskState();
  }
}

class _NewTaskState extends State<NewTask> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Category? selectedCategory; // To store the selected category

  void _submitTaskData() {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (title.isEmpty || description.isEmpty || selectedCategory == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Erreur'),
          content: const Text('Merci de remplir tous les champs.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    } else {
      final newTask = Task(
        title: title,
        description: description,
        date: DateTime.now(),
        category: selectedCategory!,
      );
      widget.addTask(newTask); // Call the function to add the task
      Navigator.pop(context); // Close the bottom sheet
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: InputDecoration(
              labelText: 'Task Title',
            ),
          ),
          TextField(
            controller: _descriptionController,
            maxLength: 50,
            decoration: InputDecoration(
              labelText: 'Task Description',
            ),
          ),
          // Dropdown to select the category
          DropdownButton<Category>(
            hint: Text('Select Category'),
            value: selectedCategory,
            onChanged: (Category? newValue) {
              setState(() {
                selectedCategory = newValue;
              });
            },
            items: Category.values
                .map<DropdownMenuItem<Category>>((Category value) {
              return DropdownMenuItem<Category>(
                value: value,
                child: Text(value.toString().split('.').last),
              );
            }).toList(),
          ),

          ElevatedButton(
            onPressed: _submitTaskData,
            child: const Text('Save Task'),
          ),
        ],
      ),
    );
  }
}
