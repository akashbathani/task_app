import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/model/task_schema.dart';
import 'package:task_app/repositories/task_repositories.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;
  List<Task> _allTasks = [];

  TaskBloc(this.taskRepository) : super(TaskInitial()) {
    on<LoadTasksEvent>((event, emit) async {
      emit(TaskLoading());
      _allTasks = await taskRepository.getTasks();
      emit(TaskLoaded(tasks: _allTasks, filter: TaskFilter.all));
    });

    on<AddTaskEvent>((event, emit) async {
      if (state is TaskLoaded) {
        _allTasks.add(event.task);
        await taskRepository.addTask(event.task);
        emit(TaskLoaded(tasks: _filterTasks((state as TaskLoaded).filter), filter: (state as TaskLoaded).filter));
      }
    });

    on<UpdateTaskEvent>((event, emit) async {
      if (state is TaskLoaded) {
        final index = _allTasks.indexWhere((task) => task.id == event.task.id);
        if (index != -1) {
          _allTasks[index] = event.task;
          await taskRepository.updateTask(event.task);
          emit(TaskLoaded(tasks: _filterTasks((state as TaskLoaded).filter), filter: (state as TaskLoaded).filter));
        }
      }
    });

    on<DeleteTaskEvent>((event, emit) async {
      if (state is TaskLoaded) {
        _allTasks.removeWhere((task) => task.id == event.taskId);
        await taskRepository.deleteTask(event.taskId);
        emit(TaskLoaded(tasks: _filterTasks((state as TaskLoaded).filter), filter: (state as TaskLoaded).filter));
      }
    });

    on<FilterTasksEvent>((event, emit) {
      if (state is TaskLoaded) {
        emit(TaskLoaded(tasks: _filterTasks(event.filter), filter: event.filter));
      }
    });
  }

  List<Task> _filterTasks(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.completed:
        return _allTasks.where((task) => task.isCompleted).toList();
      case TaskFilter.incomplete:
        return _allTasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.all:
      default:
        return _allTasks;
    }
  }
}
