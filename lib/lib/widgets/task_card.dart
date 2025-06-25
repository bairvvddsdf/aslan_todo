import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({required this.task, super.key});

  @override
  Widget build(BuildContext c) {
    final box = Hive.box<Task>('tasks');
    final clr = {
      TaskStatus.pending: Colors.orange,
      TaskStatus.inProcess: Colors.lightBlue,
      TaskStatus.completed: Colors.green,
    }[task.status]!;
    final badge = {
      TaskStatus.pending: 'Ожидает',
      TaskStatus.inProcess: 'В процессе',
      TaskStatus.completed: 'Завершено',
    }[task.status]!;

    return Dismissible(
      key: ValueKey(task.key),
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16),
        child: const Icon(Icons.arrow_forward_ios, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (d) async {
        if (d == DismissDirection.startToEnd) {
          // влево→вправо: переводим в следующий статус
          if (task.status == TaskStatus.pending) task.status = TaskStatus.inProcess;
          else if (task.status == TaskStatus.inProcess) task.status = TaskStatus.completed;
          await task.save();
          return false; // не удаляем карточку
        } else {
          // вправо→влево: удаляем
          await box.delete(task.key);
          return true;
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: clr, width: 3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: clr.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
                  child: Text(badge),
                ),
              ],
            ),
            if (task.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(task.description),
              ),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 4),
              Text(DateFormat('dd MMM yyyy г.', 'ru').format(task.dateTime)),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 16),
              const SizedBox(width: 4),
              Text(DateFormat('HH:mm').format(task.dateTime)),
            ]),
            if (task.status != TaskStatus.completed)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Проведите вправо для перехода в следующий статус • Проведите влево для удаления',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
