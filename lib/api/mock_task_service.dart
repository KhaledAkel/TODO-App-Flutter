import '../models/task.dart';

/// A mock service that simulates fetching task data from an API.
class MockTaskService {
  /// Fetches both pending and completed tasks.
  Future<TaskData> getTaskData() async {
    final pendingTasks = await _getPendingTasks();
    final completedTasks = await _getCompletedTasks();

    return TaskData(pendingTasks, completedTasks);
  }

  Future<List<Task>> _getPendingTasks() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Return mock pending tasks
    return [
      Task(
          title: "Buy groceries",
          description: "Milk, Bread, Eggs",
          dueDate: DateTime.now().add(Duration(days: 1))),
      Task(
          title: "Workout",
          description: "Go for a run",
          dueDate: DateTime.now().add(Duration(days: 2))),
    ];
  }

  Future<List<Task>> _getCompletedTasks() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Return mock completed tasks
    return [
      Task(
          title: "Finish project",
          description: "Complete the app development",
          dueDate: DateTime.now(),
          isCompleted: true),
    ];
  }
}
