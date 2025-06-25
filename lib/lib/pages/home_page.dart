import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/task_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  DateTime _selDate = DateTime.now();
  final Box<Task> _box = Hive.box<Task>('tasks');

  @override
  Widget build(BuildContext ctx) {
    return Column(
      children: [
        CalendarWidget(
          selectedDate: _selDate,
          onDateSelected: (d) => setState(() => _selDate = d),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: _box.listenable(),
            builder: (ctx, Box<Task> box, _) {
              final list = box.values.where((t) {
                final dt = t.dateTime;
                return dt.year == _selDate.year
                    && dt.month == _selDate.month
                    && dt.day == _selDate.day
                    && t.status != TaskStatus.completed;
              }).toList();
              if (list.isEmpty) {
                return const Center(child: Text('Нет задач на эту дату'));
              }
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) => TaskCard(task: list[i]),
              );
            },
          ),
        ),
      ],
    );
  }
}
