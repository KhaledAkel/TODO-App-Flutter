import 'package:flutter/material.dart';
import '../models/task.dart';
import '../components/task_card.dart';

class CompletedPage extends StatelessWidget {
  final List<Task> completedTasks;
  final Function(Task) onUncomplete; // Callback to handle uncompleting tasks

  CompletedPage({required this.completedTasks, required this.onUncomplete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
      ),
      body: ListView.builder(
        itemCount: completedTasks.length,
        itemBuilder: (context, index) {
          final task = completedTasks[index];
          return TaskCard(
            task: task,
            onComplete: () {
              // Handle complete task (not applicable here, but you could add logic if desired)
            },
            onUncomplete: () =>
                onUncomplete(task), // Call the uncomplete callback
          );
        },
      ),
    );
  }
}
