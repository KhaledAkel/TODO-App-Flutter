import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskDetailsPage extends StatelessWidget {
  final Task task;
  final Function(Task) onTaskUpdated;
  final Function(Task) onTaskDeleted;

  TaskDetailsPage({
    required this.task,
    required this.onTaskUpdated,
    required this.onTaskDeleted,
  });

  @override
  Widget build(BuildContext context) {
    String title = task.title;
    String description = task.description;
    DateTime dueDate = task.dueDate;

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              onTaskDeleted(task);
              Navigator.pop(context); // Go back after deletion
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Task Title'),
              onChanged: (value) {
                title = value;
              },
              controller: TextEditingController(text: task.title),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Task Description'),
              onChanged: (value) {
                description = value;
              },
              controller: TextEditingController(text: task.description),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Due Date'),
              readOnly: true,
              onTap: () async {
                // Implement date picker
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: dueDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  dueDate = pickedDate; // Update due date
                }
              },
              controller: TextEditingController(
                  text: dueDate.toLocal().toString().split(' ')[0]),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (title.isNotEmpty && description.isNotEmpty) {
                  // Create a new task with updated details
                  Task updatedTask = Task(
                    title: title,
                    description: description,
                    dueDate: dueDate,
                    isCompleted: task.isCompleted,
                  );
                  onTaskUpdated(updatedTask); // Update the task
                  Navigator.pop(context); // Go back to the pending page
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields.')),
                  );
                }
              },
              child: Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}
