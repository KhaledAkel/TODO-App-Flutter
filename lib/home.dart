import 'package:flutter/material.dart';
import 'screens/pending_page.dart';
import 'screens/completed_page.dart';
import 'models/task.dart';
import 'api/mock_task_service.dart';

/// The `HomePage` widget is the main screen of the app, displaying two tabs:
/// Pending tasks and Completed tasks. Users can switch between the two tabs using
/// a bottom navigation bar or a navigation rail (depending on screen size).
///
/// This page handles task management logic, including loading tasks from a mock service,
/// updating task completion status, and adding or deleting tasks.

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex =
      0; // Tracks the current tab index (0: Pending, 1: Completed)
  List<Task> _pendingTasks = []; // List of pending tasks
  List<Task> _completedTasks = []; // List of completed tasks
  final MockTaskService _taskService =
      MockTaskService(); // Service to load mock task data

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Load tasks when the widget is initialized
  }

  /// Loads tasks from the mock task service and updates the state.
  /// Pending and completed tasks are separated and stored in different lists.
  Future<void> _loadTasks() async {
    final taskData = await _taskService.getTaskData();
    setState(() {
      _pendingTasks = taskData.pendingTasks;
      _completedTasks = taskData.completedTasks;
    });
  }

  /// Marks a task as completed, moving it from the pending list to the completed list.
  void _onTaskCompleted(Task task) {
    setState(() {
      _pendingTasks.remove(task);
      task.isCompleted = true;
      _completedTasks.add(task);
    });
  }

  /// Marks a task as uncompleted, moving it from the completed list back to the pending list.
  void _onTaskUncompleted(Task task) {
    setState(() {
      _completedTasks.remove(task);
      task.isCompleted = false;
      _pendingTasks.add(task);
    });
  }

  /// Updates the details of a task in the pending list.
  void _onTaskUpdated(Task updatedTask) {
    setState(() {
      int index =
          _pendingTasks.indexWhere((task) => task.title == updatedTask.title);
      if (index != -1) {
        _pendingTasks[index] =
            updatedTask; // Update the task at the found index
      }
    });
  }

  /// Deletes a task from the pending list.
  void _onTaskDeleted(Task deletedTask) {
    setState(() {
      _pendingTasks.remove(deletedTask);
    });
  }

  /// Adds a new task to the pending list.
  void _onTaskAdded(Task newTask) {
    setState(() {
      _pendingTasks.add(newTask); // Append the new task to the list
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
        onTaskAdded: _onTaskAdded, // Pass callback to add tasks
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
          // Render a NavigationRail for larger screens (width > 600 pixels)
          if (constraints.maxWidth > 600) {
            return Row(
              children: [
                NavigationRail(
                  backgroundColor: Colors.white, // Set rail background color
                  selectedIndex: _currentIndex, // Track the current selection
                  onDestinationSelected: (index) {
                    setState(() {
                      _currentIndex =
                          index; // Update the tab index when selected
                    });
                  },
                  destinations: [
                    // Navigation option for the pending tasks
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
                    // Navigation option for the completed tasks
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
                    color: Colors.blue[800], // Style for selected label
                  ),
                  unselectedLabelTextStyle: TextStyle(
                    color: Colors.grey, // Style for unselected label
                  ),
                  indicatorColor:
                      Colors.transparent, // Custom styling for indicator
                ),
                VerticalDivider(
                    thickness: 1, width: 1), // Divider between rail and content
                Expanded(
                    child: pages[_currentIndex]), // Display the selected page
              ],
            );
          } else {
            // For smaller screens, use a bottom navigation bar
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
                  _currentIndex = index; // Update the tab index when selected
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
          : null, // Only show the bottom navigation bar for smaller screens
    );
  }
}
