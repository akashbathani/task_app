import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/controllers/task_event.dart';
import 'package:task_app/repositories/task_repositories.dart';
import 'controllers/task_bloc.dart';
import 'screens/task_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final taskRepository = TaskRepository(sharedPreferences: sharedPreferences);

  runApp(MyApp(taskRepository: taskRepository));
}

class MyApp extends StatelessWidget {
  final TaskRepository taskRepository;

  const MyApp({Key? key, required this.taskRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TaskBloc(taskRepository)..add(LoadTasksEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'To-Do App',
        color: Color(0xFFD9D4C4),
        home: TaskListScreen(),
      ),
    );
  }
}
