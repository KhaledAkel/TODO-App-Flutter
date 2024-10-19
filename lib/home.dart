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

  void _onTaskUpdated(Task updatedTask) {
    setState(() {
      int index =
          _pendingTasks.indexWhere((task) => task.title == updatedTask.title);
      if (index != -1) {
        _pendingTasks[index] = updatedTask;
      }
    });
  }

  void _onTaskDeleted(Task deletedTask) {
    setState(() {
      _pendingTasks.remove(deletedTask);
    });
  }

  void _onTaskAdded(Task newTask) {
    setState(() {
      _pendingTasks.add(newTask); // Add the new task to the pending list
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      PendingPage(
        pendingTasks: _pendingTasks,
        onTaskCompleted: _onTaskCompleted,
        onTaskDeleted: _onTaskDeleted,
        onTaskUpdated: _onTaskUpdated,
        onTaskAdded: _onTaskAdded, // Pass the new callback
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
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // If the screen is wider than 600 pixels
            return Row(
              children: [
                NavigationRail(
                  backgroundColor: Colors.white, // Match the background color
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  destinations: [
                    NavigationRailDestination(
                      icon: Container(
                        decoration: BoxDecoration(
                          color: _currentIndex == 0
                              ? Colors.white
                              : Colors.transparent,
                          border: _currentIndex == 0
                              ? Border.all(color: Colors.blue[800]!)
                              : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.task,
                          color: _currentIndex == 0
                              ? Colors.blue[800]
                              : Colors.grey,
                        ),
                      ),
                      label: Text('Pending Tasks'),
                    ),
                    NavigationRailDestination(
                      icon: Container(
                        decoration: BoxDecoration(
                          color: _currentIndex == 1
                              ? Colors.white
                              : Colors.transparent,
                          border: _currentIndex == 1
                              ? Border.all(color: Colors.blue[800]!)
                              : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.check,
                          color: _currentIndex == 1
                              ? Colors.blue[800]
                              : Colors.grey,
                        ),
                      ),
                      label: Text('Completed Tasks'),
                    ),
                  ],
                  selectedLabelTextStyle: TextStyle(
                    color: Colors.blue[800], // Selected item text color
                  ),
                  unselectedLabelTextStyle: TextStyle(
                    color: Colors.grey, // Unselected item text color
                  ),
                  indicatorColor:
                      Colors.transparent, // Remove indicator for custom styling
                ),
                VerticalDivider(thickness: 1, width: 1),
                Expanded(child: pages[_currentIndex]),
              ],
            );
          } else {
            return IndexedStack(index: _currentIndex, children: pages);
          }
        },
      ),
      bottomNavigationBar: (MediaQuery.of(context).size.width <= 600)
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: Colors.blue[800],
              unselectedItemColor: Colors.grey,
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
            )
          : null,
    );
  }
}
