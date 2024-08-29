import '../model/task_schema.dart';

abstract class TaskEvent {}

class LoadTasksEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final Task task;

  AddTaskEvent(this.task);
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;

  UpdateTaskEvent(this.task);
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;

  DeleteTaskEvent(this.taskId);
}

class FilterTasksEvent extends TaskEvent {
  final TaskFilter filter;

  FilterTasksEvent(this.filter);
}

enum TaskFilter { all, completed, incomplete }
