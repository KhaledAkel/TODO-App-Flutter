import 'package:flutter/material.dart';
import '../models/task.dart';
import '../components/task_card.dart';

class CompletedPage extends StatelessWidget {
  final List<Task> completedTasks; // Accept completed tasks

  CompletedPage({required this.completedTasks});

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
              // Optional: Implement uncomplete functionality if desired
              // For now, we just have a placeholder
            },
          );
        },
      ),
    );
  }
}
