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
  List<Task> _pendingTasks = [];
  List<Task> _completedTasks = [];
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
      _pendingTasks.remove(task);
      task.isCompleted = true;
      _completedTasks.add(task);
    });
  }

  void _onTaskUncompleted(Task task) {
    setState(() {
      _completedTasks.remove(task);
      task.isCompleted = false;
      _pendingTasks.add(task);
    });
  }

  void _addNewTask(String title, String description, DateTime dueDate) {
    final newTask = Task(
      title: title,
      description: description,
      dueDate: dueDate,
      isCompleted: false,
    );

    setState(() {
      _pendingTasks.add(newTask);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      PendingPage(
        pendingTasks: _pendingTasks,
        onTaskCompleted: _onTaskCompleted,
        onTaskAdded: _addNewTask, // Pass the add task method here
      ),
      CompletedPage(
        completedTasks: _completedTasks,
        onUncomplete: _onTaskUncompleted,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tasko',
          style: TextStyle(
              color: Colors.blue[800],
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType
            .fixed, // Prevents the whole bar from animating
        backgroundColor: Colors.white,
        selectedItemColor:
            Colors.blue[800], // Dark blue color for selected icon
        unselectedItemColor: Colors.grey, // Gray color for unselected icons
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Pending Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Completed Tasks',
          ),
        ],
      ),
    );
  }
}
