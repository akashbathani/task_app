import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/controllers/task_bloc.dart';
import 'package:task_app/controllers/task_event.dart';
import 'package:task_app/controllers/task_state.dart';
import 'package:task_app/screens/add_task_screen.dart';
import '../widgets/task_tile.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D4C4),
      appBar: AppBar(
        title: const Text('To-Do List'),
        backgroundColor: const Color(0xFFD9D4C4),
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            color: const Color(0xFFD9D4C4),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: TaskFilter.values.map((filter) {
                return GestureDetector(
                  onTap: () => context.read<TaskBloc>().add(FilterTasksEvent(filter)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getFilterText(filter),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TaskLoaded) {
                  if (state.tasks.isEmpty) {
                    return const Center(child: Text('No data found.'));
                  }
                  return ListView.builder(
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      final task = state.tasks[index];
                      return TaskTile(task: task, index: index);
                    },
                  );
                } else {
                  return const Center(child: Text('Something went wrong.'));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddTaskScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _getFilterText(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.all:
        return 'All';
      case TaskFilter.completed:
        return 'Completed';
      case TaskFilter.incomplete:
        return 'Incomplete';
    }
  }
}
