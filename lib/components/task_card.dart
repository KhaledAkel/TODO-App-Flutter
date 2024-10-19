import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onComplete; // Callback to mark task as complete
  final VoidCallback onUncomplete; // Callback to uncomplete or remove the task

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
