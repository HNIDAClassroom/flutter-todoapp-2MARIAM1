import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/services/firestore.dart';

class NewTask extends StatefulWidget {
  // final Function(Task) addTask;

  const NewTask({Key? key}) : super(key: key); //this.addTask,
  @override
  State<NewTask> createState() {
    return _NewTaskState();
  }
}

class _NewTaskState extends State<NewTask> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Category selectedCategory = Category.personal;
  final FirestoreService _firestoreService = FirestoreService();
  DateTime selectedDateTime = DateTime.now();

  Future<void> _selectDateAndTime(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      // ignore: use_build_context_synchronously
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );
      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _submitTaskData() {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (title.isEmpty || description.isEmpty) {
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
        date: selectedDateTime,
        category: selectedCategory,
        isCompleted: false,
      );

      setState(() {
        // widget.addTask(newTask);
        _firestoreService.addTask(newTask);
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                maxLength: 300,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Task Description',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Dropdown to select the category
              DropdownButton<Category>(
                hint: Text('Select Category'),
                icon: Icon(Icons.arrow_drop_down_circle_outlined),
                elevation: 10,
                value: selectedCategory,
                isExpanded: true,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    selectedCategory = value;
                  });
                },
                items: Category.values
                    .map((category) => DropdownMenuItem<Category>(
                          value: category,
                          child: Text(
                            category.name,
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () => _selectDateAndTime(
                      context), // Button to select date and time
                  child: Text(
                      'Selected Date & Time: ${DateFormat.yMMMd().add_jm().format(selectedDateTime)}'),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 50),
                  backgroundColor: Colors.deepPurpleAccent),
              onPressed: _submitTaskData,
              child: Text(
                'Save Task',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
