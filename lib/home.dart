import 'package:flutter/material.dart';
import 'screens/pending_page.dart';
import 'screens/completed_page.dart';
import 'models/task.dart';
import 'api/mock_task_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Task> _completedTasks = [];
  List<Task> _pendingTasks = [];
  final MockTaskService _taskService = MockTaskService();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final taskData = await _taskService.getTaskData();
    setState(() {
      _pendingTasks = taskData.pendingTasks;
      _completedTasks = taskData.completedTasks;
    });
  }

  void _onTaskCompleted(Task task) {
    setState(() {
      // Remove the task from pending tasks and mark it as completed
      _pendingTasks.remove(task); // Remove from pending
      task.isCompleted = true; // Mark the task as completed
      _completedTasks.add(task); // Add to completed tasks
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      PendingPage(onTaskCompleted: _onTaskCompleted), // Pass the callback
      CompletedPage(completedTasks: _completedTasks), // Pass completed tasks
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Tasko'),
      ),
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.task),
            label: 'Pending Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.check),
            label: 'Completed Tasks',
          ),
        ],
      ),
    );
  }
}
