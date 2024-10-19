import 'package:flutter/material.dart';
import '../models/task.dart';
import '../components/task_card.dart';

/// A stateless widget that displays a list of completed tasks.
///
/// The [CompletedPage] widget shows a list of tasks that have been marked as completed.
/// Each task is displayed using a [TaskCard] widget, which includes an option to mark
/// the task as uncompleted.
class CompletedPage extends StatelessWidget {
  /// A list of tasks that have been completed.
  final List<Task> completedTasks;

  /// Callback function to handle marking a task as uncompleted.
  final Function(Task) onUncomplete;

  /// Creates a [CompletedPage] widget.
  ///
  /// The [completedTasks] and [onUncomplete] parameters are required.
  CompletedPage({
    required this.completedTasks,
    required this.onUncomplete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
      ),
      body: ListView.builder(
        itemCount: completedTasks.length,
        itemBuilder: (context, index) {
          final task = completedTasks[index];
          return TaskCard(
            task: task,
            onComplete: () {
              // Handle complete task (not applicable here, but you could add logic if desired)
            },
            onUncomplete: () =>
                onUncomplete(task), // Call the uncomplete callback
          );
        },
      ),
    );
  }
}
