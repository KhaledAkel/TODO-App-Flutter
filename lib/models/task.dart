// task.dart

class Task {
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
  });
}

class TaskData {
  final List<Task> pendingTasks;
  final List<Task> completedTasks;

  TaskData(this.pendingTasks, this.completedTasks);
}
