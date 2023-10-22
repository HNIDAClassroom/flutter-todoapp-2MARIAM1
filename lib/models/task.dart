import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum Category { personal, work, shopping, other }

class Task {
  Task({
    required this.title,
    required this.description,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final String description;
  final DateTime date;
  final Category category;

  // Convert task to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'category': category.toString().split('.').last, // Convert enum to string
    };
  }

  // Create a task from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      category: _getCategoryFromString(json['category']),
    );
  }

  // Helper function to convert a string to Category enum
  static Category _getCategoryFromString(String categoryString) {
    return Category.values.firstWhere(
      (e) => e.toString().split('.').last == categoryString,
      orElse: () => Category.other, // Default to 'other' if not found
    );
  }
}
