import 'package:flutter/material.dart';
import '../models/task.dart';
import '../components/task_card.dart';
import 'task_details_page.dart'; // Import the task details page

class PendingPage extends StatelessWidget {
  final List<Task> pendingTasks;
  final Function(Task) onTaskCompleted;
  final Function(Task) onTaskDeleted;
  final Function(Task) onTaskUpdated;
  final Function(Task) onTaskAdded; // Added onTaskAdded

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
        title: Text('Pending Tasks'),
      ),
      body: ListView.builder(
        itemCount: pendingTasks.length,
        itemBuilder: (context, index) {
          final task = pendingTasks[index];
          return GestureDetector(
            onTap: () {
              // Navigate to the TaskDetailsPage on task click
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailsPage(
                    task: task,
                    onTaskUpdated: (updatedTask) {
                      onTaskUpdated(updatedTask);
                    },
                    onTaskDeleted: (deletedTask) {
                      onTaskDeleted(deletedTask);
                    },
                  ),
                ),
              );
            },
            child: TaskCard(
              task: task,
              onComplete: () => onTaskCompleted(task),
              onUncomplete: () {
                // No action needed for pending tasks
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTask(context),
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.blue[800]),
      ),
    );
  }

  void _addTask(BuildContext context) {
    String title = '';
    String description = '';
    DateTime? dueDate;
    TimeOfDay? dueTime; // Added due time variable

    final TextEditingController dueDateController = TextEditingController();
    final TextEditingController dueTimeController =
        TextEditingController(); // Controller for due time text field

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
              TextField(
                decoration: InputDecoration(labelText: 'Task Title'),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Task Description'),
                onChanged: (value) {
                  description = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Due Date'),
                readOnly: true,
                controller: dueDateController, // Set the controller here
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: dueDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    dueDate = pickedDate; // Update due date
                    dueDateController.text = dueDate!
                        .toLocal()
                        .toString()
                        .split(' ')[0]; // Update the text in the controller
                  }
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Due Time'),
                readOnly: true,
                controller: dueTimeController, // Set the controller here
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: dueTime ?? TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    dueTime = pickedTime; // Update due time
                    dueTimeController.text =
                        '${dueTime!.hour}:${dueTime!.minute.toString().padLeft(2, '0')}'; // Update the text in the controller
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (title.isNotEmpty &&
                      description.isNotEmpty &&
                      dueDate != null &&
                      dueTime != null) {
                    // Call the function to add the task
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
                    onTaskAdded(newTask); // Call the added callback
                    Navigator.pop(context); // Close the bottom sheet
                  } else {
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
