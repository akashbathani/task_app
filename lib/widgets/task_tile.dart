import 'package:flutter/material.dart';
import 'package:task_app/controllers/task_bloc.dart';
import 'package:task_app/controllers/task_event.dart';
import 'package:task_app/model/task_schema.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/screens/edit_task_screen.dart'; // Import your EditTaskScreen

class TaskTile extends StatelessWidget {
  final Task task;
  final int index;

  const TaskTile({super.key, required this.task, required this.index});

  @override
  Widget build(BuildContext context) {
    final List<Color> tileColors = [
      const Color(0xFFC4C5D9),
      const Color(0xFFD9C4C4),
      const Color(0xFFC4D9D5),
    ];

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${task.title} deleted')),
          );
        }
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        color: Colors.red,
        child: IconButton(
          icon: const Icon(Icons.delete, color: Colors.white),
          onPressed: () {
            context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
          },
        ),
      ),
      child: GestureDetector(
        onTap: () {
          context.read<TaskBloc>().add(
                UpdateTaskEvent(task.copyWith(isCompleted: !task.isCompleted)),
              );
        },
        child: Card(
          color: tileColors[index % tileColors.length],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(task.title,
                            style: const TextStyle(fontSize: 18))),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.black),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => EditTaskScreen(task: task)),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        task.title ?? '',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color:
                                task.isCompleted ? Colors.green : Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            task.isCompleted ? 'Completed' : 'Pending',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
