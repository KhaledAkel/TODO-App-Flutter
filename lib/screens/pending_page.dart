import 'package:flutter/material.dart';
import '../api/mock_task_service.dart';
import '../models/task.dart';
import '../components/task_card.dart';

class PendingPage extends StatefulWidget {
  final Function(Task) onTaskCompleted; // Callback to notify completion

  PendingPage({required this.onTaskCompleted}); // Expect this parameter

  @override
  _PendingPageState createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPage> {
  final MockTaskService _taskService = MockTaskService();
  late Future<TaskData> _taskData;

  @override
  void initState() {
    super.initState();
    _taskData = _taskService.getTaskData();
  }

  Future<void> _addTask() async {
    // Placeholder for add task functionality
    // You can implement the dialog or bottom sheet here to add a new task
  }

  void _completeTask(Task task) {
    // Notify the HomePage that the task is completed
    widget.onTaskCompleted(task); // Call the passed callback
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Tasks'),
      ),
      body: FutureBuilder<TaskData>(
        future: _taskData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final tasks = snapshot.data!.pendingTasks;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskCard(
                task: task,
                onComplete: () =>
                    _completeTask(task), // Pass the task to complete
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: Icon(Icons.add),
      ),
    );
  }
}
