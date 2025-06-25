import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/task.dart';
import 'pages/home_page.dart';
import 'pages/stats_page.dart';
import 'widgets/add_task_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  Hive.registerAdapter(TaskStatusAdapter());
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Планировщик Задач',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: const MainPage(),
  );
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {
  int _sel = 0;
  final _pages = const [ HomePage(), StatsPage() ];

  void _showAdd() {
    showDialog(context: context, builder: (_) => const AddTaskDialog());
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Планировщик Задач'),
        actions: [ TextButton(onPressed: _showAdd, child: const Text('+ Добавить', style: TextStyle(color: Colors.white))) ],
      ),
      body: _pages[_sel],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _sel,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Статистика'),
        ],
        onTap: (i) => setState(() => _sel = i),
      ),
    );
  }
}
