import 'package:flutter/material.dart';

/// Represents a task with a title, description, due date, and completion status.
class Task {
  /// The title of the task.
  final String title;

  /// A detailed description of the task.
  final String description;

  /// The due date of the task.
  final DateTime dueDate;

  /// The due time of the task.
  final TimeOfDay? dueTime; // New property for due time

  /// Indicates whether the task is completed.
  /// Defaults to `false`.
  bool isCompleted;

  /// Creates a new [Task] instance.
  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    this.dueTime,
    this.isCompleted = false,
  });
}

/// Holds lists of pending and completed tasks.
class TaskData {
  /// A list of tasks that are pending.
  final List<Task> pendingTasks;

  /// A list of tasks that are completed.
  final List<Task> completedTasks;

  /// Creates a new [TaskData] instance with the given lists of pending and completed tasks.
  TaskData(this.pendingTasks, this.completedTasks);
}
