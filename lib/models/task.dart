// task.dart

/// Represents a task with a title, description, due date, and completion status.
class Task {
  /// The title of the task.
  final String title;

  /// A detailed description of the task.
  final String description;

  /// The due date of the task.
  final DateTime dueDate;

  /// Indicates whether the task is completed.
  /// Defaults to `false`.
  bool isCompleted;

  /// Creates a new [Task] instance.
  ///
  /// The [title], [description], and [dueDate] parameters are required.
  /// The [isCompleted] parameter is optional and defaults to `false`.
  Task({
    required this.title,
    required this.description,
    required this.dueDate,
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
  ///
  /// The [pendingTasks] and [completedTasks] parameters are required.
  TaskData(this.pendingTasks, this.completedTasks);
}
