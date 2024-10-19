import 'package:flutter/material.dart';
import '../models/task.dart';
import '../components/task_card.dart';
import 'task_details_page.dart'; // Import the task details page

/// This page shows the list of pending tasks and allows users to complete,
/// delete, or update tasks. It also allows users to add new tasks.
class PendingPage extends StatelessWidget {
  final List<Task> pendingTasks; // List of pending tasks to display
  final Function(Task)
      onTaskCompleted; // Callback for when a task is marked as complete
  final Function(Task) onTaskDeleted; // Callback for when a task is deleted
  final Function(Task) onTaskUpdated; // Callback for when a task is updated
  final Function(Task) onTaskAdded; // Callback for when a new task is added

  /// Constructor for the `PendingPage`, taking in required callbacks and a list of tasks.
  PendingPage({
    required this.pendingTasks,
    required this.onTaskCompleted,
    required this.onTaskDeleted,
    required this.onTaskUpdated,
    required this.onTaskAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Tasks'), // Title of the app bar
      ),
      // List of pending tasks is displayed here
      body: ListView.builder(
        itemCount: pendingTasks.length, // Number of tasks in the list
        itemBuilder: (context, index) {
          final task = pendingTasks[index]; // Get each task
          return GestureDetector(
            onTap: () {
              // Navigate to the `TaskDetailsPage` when a task is clicked
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailsPage(
                    task: task,
                    onTaskUpdated: (updatedTask) {
                      onTaskUpdated(updatedTask); // Update the task
                    },
                    onTaskDeleted: (deletedTask) {
                      onTaskDeleted(deletedTask); // Delete the task
                    },
                  ),
                ),
              );
            },
            // Display each task in a `TaskCard` widget
            child: TaskCard(
              task: task,
              onComplete: () => onTaskCompleted(task), // Mark task as completed
              onUncomplete: () {
                // No action needed for pending tasks
              },
            ),
          );
        },
      ),
      // Button to add new tasks
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTask(context), // Opens the form to add a new task
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.blue[800]), // Icon for add button
      ),
    );
  }

  /// Method to show a modal bottom sheet for adding a new task.
  void _addTask(BuildContext context) {
    String title = ''; // Variable to hold the task title
    String description = ''; // Variable to hold the task description
    DateTime? dueDate; // Variable to hold the due date
    TimeOfDay? dueTime; // Variable to hold the due time

    final TextEditingController dueDateController =
        TextEditingController(); // Controller for due date field
    final TextEditingController dueTimeController =
        TextEditingController(); // Controller for due time field

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text field to input task title
              TextField(
                decoration: InputDecoration(labelText: 'Task Title'),
                onChanged: (value) {
                  title = value; // Update task title
                },
              ),
              // Text field to input task description
              TextField(
                decoration: InputDecoration(labelText: 'Task Description'),
                onChanged: (value) {
                  description = value; // Update task description
                },
              ),
              // Text field to input due date, opens a date picker when tapped
              TextField(
                decoration: InputDecoration(labelText: 'Due Date'),
                readOnly: true,
                controller: dueDateController, // Controller for due date field
                onTap: () async {
                  FocusScope.of(context).unfocus(); // Close keyboard
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: dueDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    dueDate = pickedDate; // Set due date
                    dueDateController.text = dueDate!
                        .toLocal()
                        .toString()
                        .split(' ')[0]; // Display selected date
                  }
                },
              ),
              // Text field to input due time, opens a time picker when tapped
              TextField(
                decoration: InputDecoration(labelText: 'Due Time'),
                readOnly: true,
                controller: dueTimeController, // Controller for due time field
                onTap: () async {
                  FocusScope.of(context).unfocus(); // Close keyboard
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: dueTime ?? TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    dueTime = pickedTime; // Set due time
                    dueTimeController.text =
                        '${dueTime!.hour}:${dueTime!.minute.toString().padLeft(2, '0')}'; // Display selected time
                  }
                },
              ),
              // Button to add the task
              ElevatedButton(
                onPressed: () {
                  if (title.isNotEmpty &&
                      description.isNotEmpty &&
                      dueDate != null &&
                      dueTime != null) {
                    // Create new task with input data
                    final newTask = Task(
                      title: title,
                      description: description,
                      dueDate: DateTime(
                        dueDate!.year,
                        dueDate!.month,
                        dueDate!.day,
                        dueTime!.hour,
                        dueTime!.minute,
                      ),
                    );
                    onTaskAdded(newTask); // Add the new task via callback
                    Navigator.pop(context); // Close the bottom sheet
                  } else {
                    // Show error message if any field is empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in all fields.')),
                    );
                  }
                },
                child: Text('Add Task'),
              ),
            ],
          ),
        );
      },
    );
  }
}
