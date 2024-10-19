import 'package:flutter/material.dart';
import '../models/task.dart';

/// A widget that displays a card with task details.
///
/// The card includes the task's title, description, due date, and an icon
/// button to mark the task as completed or uncompleted.
class TaskCard extends StatelessWidget {
  /// The task to be displayed in the card.
  final Task task;

  /// Callback to mark the task as complete.
  final VoidCallback onComplete;

  /// Callback to mark the task as uncomplete or remove the task.
  final VoidCallback onUncomplete;

  /// Creates a [TaskCard] widget.
  ///
  /// The [task], [onComplete], and [onUncomplete] parameters are required.
  const TaskCard({
    Key? key,
    required this.task,
    required this.onComplete,
    required this.onUncomplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format the due date and time using built-in methods
    String dueDateFormatted =
        "${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year} ${task.dueDate.hour}:${task.dueDate.minute.toString().padLeft(2, '0')}";

    return Card(
      color: Colors.white, // Set card color to white
      elevation: 2, // Optional: adds some elevation for depth
      child: ListTile(
        title: Text(task.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.description),
            SizedBox(height: 4), // Add some spacing
            Text(
              'Due: $dueDateFormatted', // Display due date and time
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: task.isCompleted
            ? IconButton(
                icon: Icon(Icons.close,
                    color: Colors.red), // Close icon for completed tasks
                onPressed: onUncomplete, // Call the onUncomplete callback
              )
            : IconButton(
                icon: Icon(Icons.check,
                    color: Colors.green), // Check icon for pending tasks
                onPressed: onComplete, // Call the onComplete callback
              ),
      ),
    );
  }
}
