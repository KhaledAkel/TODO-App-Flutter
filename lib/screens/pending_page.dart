import 'package:flutter/material.dart';
import '../models/task.dart';
import '../components/task_card.dart';

class PendingPage extends StatelessWidget {
  final List<Task> pendingTasks;
  final Function(Task) onTaskCompleted;
  final Function(String, String, DateTime)
      onTaskAdded; // Callback for adding tasks

  PendingPage({
    required this.pendingTasks,
    required this.onTaskCompleted,
    required this.onTaskAdded, // Add this parameter
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Tasks'),
      ),
      body: ListView.builder(
        itemCount: pendingTasks.length,
        itemBuilder: (context, index) {
          final task = pendingTasks[index];
          return TaskCard(
            task: task,
            onComplete: () =>
                onTaskCompleted(task), // Call the callback when completed
            onUncomplete: () {
              // No action needed for pending tasks
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTask(context), // Call the add task method
        backgroundColor: Colors.white, // Set FAB background to white
        child: Icon(Icons.add,
            color: Colors.blue[800]), // Set FAB icon color to blue
      ),
    );
  }

  void _addTask(BuildContext context) {
    String title = '';
    String description = '';
    DateTime? dueDate;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white, // Set the background color to white
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(16)), // Optional: rounded corners
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Task Title'),
                onChanged: (value) {
                  title = value; // Capture the title input
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Task Description'),
                onChanged: (value) {
                  description = value; // Capture the description input
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Due Date'),
                readOnly: true, // Make the text field read-only
                onTap: () async {
                  FocusScope.of(context).unfocus(); // Dismiss the keyboard
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: dueDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    dueDate = pickedDate; // Capture the due date
                  }
                },
                controller: TextEditingController(
                    text: dueDate != null
                        ? dueDate!.toLocal().toString().split(' ')[0]
                        : ''), // Display the selected date
              ),
              ElevatedButton(
                onPressed: () {
                  if (title.isNotEmpty &&
                      description.isNotEmpty &&
                      dueDate != null) {
                    // Call the function to add the task
                    onTaskAdded(
                        title, description, dueDate!); // Force unwrapping
                    Navigator.pop(context); // Close the bottom sheet
                  } else {
                    // Optionally show an error message if fields are empty
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
