import 'package:task_app/controllers/task_event.dart';

import '../model/task_schema.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final TaskFilter filter;

  TaskLoaded({required this.tasks, required this.filter});
}
class TaskError extends TaskState {
  final String message;

  TaskError(this.message);
}
