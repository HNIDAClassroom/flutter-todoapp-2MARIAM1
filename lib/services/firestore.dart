import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class FirestoreService {
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(Task task) {
    return FirebaseFirestore.instance.collection('tasks').add(
      {
        'taskTitle': task.title.toString(),
        'taskDesc': task.description.toString(),
        'taskCategory': task.category.toString(),
        'taskDate': task.date.toIso8601String(),
        'taskReference': task.reference,
        'isCompleted': task.isCompleted
      },
    );
  }

  Future<void> deleteTask(DocumentReference reference) {
    return reference.delete();
  }

  Future<void> updateTask(DocumentReference reference, String modifiedTitle,
      String modifiedDescription) {
    return reference.update({
      'taskTitle': modifiedTitle,
      'taskDesc': modifiedDescription,
    });
  }

  Future<void> updateTaskCompletion(
      DocumentReference reference, bool isCompleted) {
    return reference.update({'isCompleted': isCompleted});
  }

  Stream<QuerySnapshot> getTasks() {
    final taskStream = tasks.snapshots();
    return taskStream;
  }
}
