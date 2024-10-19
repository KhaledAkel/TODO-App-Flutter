import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onComplete; // Callback for when the task is completed

  TaskCard(
      {required this.task,
      required this.onComplete}); // Make sure to require onComplete

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(task.description),
        trailing: IconButton(
          icon: Icon(Icons.check),
          onPressed: onComplete, // Call the onComplete callback when pressed
        ),
      ),
    );
  }
}
