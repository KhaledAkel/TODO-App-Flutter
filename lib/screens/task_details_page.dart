import 'package:flutter/material.dart';
import '../models/task.dart';

/// TaskDetailsPage allows users to view and update details of a specific task.
/// It provides fields for editing the task's title, description, due date, and due time.
/// Users can also delete the task from this page.
class TaskDetailsPage extends StatelessWidget {
  final Task task; // The task whose details are being viewed and edited
  final Function(Task) onTaskUpdated; // Callback for when a task is updated
  final Function(Task) onTaskDeleted; // Callback for when a task is deleted

  /// Constructor for `TaskDetailsPage`, accepting the task to be displayed and
  /// callbacks for updating and deleting the task.
  TaskDetailsPage({
    required this.task,
    required this.onTaskUpdated,
    required this.onTaskDeleted,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize variables with task's current data
    String title = task.title;
    String description = task.description;
    DateTime dueDate = task.dueDate;
    TimeOfDay dueTime = task.dueTime ??
        TimeOfDay.now(); // Default to current time if none is set

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'), // App bar title
        actions: [
          // Button to delete the task
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              onTaskDeleted(task); // Call the deletion callback
              Navigator.pop(context); // Go back after deletion
            },
          ),
        ],
      ),
      // Main content area to display and edit task details
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Text field to edit the task title
            TextField(
              decoration: InputDecoration(labelText: 'Task Title'),
              onChanged: (value) {
                title = value; // Update the title when changed
              },
              controller: TextEditingController(
                  text: task.title), // Set initial value to task's title
            ),
            // Text field to edit the task description
            TextField(
              decoration: InputDecoration(labelText: 'Task Description'),
              onChanged: (value) {
                description = value; // Update the description when changed
              },
              controller: TextEditingController(
                  text: task
                      .description), // Set initial value to task's description
            ),
            // Text field to select the due date, opens a date picker on tap
            TextField(
              decoration: InputDecoration(labelText: 'Due Date'),
              readOnly: true, // Read-only field, opens date picker
              onTap: () async {
                // Show date picker dialog
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: dueDate, // Set initial value to task's due date
                  firstDate:
                      DateTime.now(), // Restrict to dates starting from today
                  lastDate: DateTime(2101), // Restrict to a future date
                );
                if (pickedDate != null) {
                  dueDate = pickedDate; // Update due date if a date is selected
                }
              },
              controller: TextEditingController(
                text: dueDate
                    .toLocal()
                    .toString()
                    .split(' ')[0], // Display due date in YYYY-MM-DD format
              ),
            ),
            // Text field to select the due time, opens a time picker on tap
            TextField(
              decoration: InputDecoration(labelText: 'Due Time'),
              readOnly: true, // Read-only field, opens time picker
              onTap: () async {
                // Show time picker dialog
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: dueTime, // Set initial value to task's due time
                );
                if (pickedTime != null) {
                  dueTime = pickedTime; // Update due time if a time is selected
                }
              },
              controller: TextEditingController(
                text:
                    '${dueTime.hour}:${dueTime.minute.toString().padLeft(2, '0')}', // Display due time in HH:mm format
              ),
            ),
            SizedBox(height: 20), // Spacer
            // Button to update the task with new details
            ElevatedButton(
              onPressed: () {
                if (title.isNotEmpty && description.isNotEmpty) {
                  // Create a new task with the updated details
                  Task updatedTask = Task(
                    title: title,
                    description: description,
                    dueDate: dueDate,
                    dueTime: dueTime,
                    isCompleted: task
                        .isCompleted, // Keep the completion status unchanged
                  );
                  onTaskUpdated(updatedTask); // Call the update callback
                  Navigator.pop(context); // Go back to the previous page
                } else {
                  // Show an error message if any required field is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields.')),
                  );
                }
              },
              child: Text('Update Task'), // Label for the update button
            ),
          ],
        ),
      ),
    );
  }
}
