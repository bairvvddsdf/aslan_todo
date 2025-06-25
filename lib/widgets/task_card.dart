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

    // Цвет и текст бейджа в зависимости от статуса
    final color = {
      TaskStatus.pending: Colors.orange,
      TaskStatus.inProcess: Colors.lightBlue,
      TaskStatus.completed: Colors.green,
    }[task.status]!;

    final badgeText = {
      TaskStatus.pending: 'Ожидает',
      TaskStatus.inProcess: 'В процессе',
      TaskStatus.completed: 'Завершено',
    }[task.status]!;

    return Dismissible(
      key: ValueKey(task.key),
      direction: DismissDirection.startToEnd, // только свайп вправо для удаления
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => box.delete(task.key),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок и статус
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(color: color),
                    ),
                  ),
                ],
              ),

              // Описание
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(task.description),
              ],

              const SizedBox(height: 8),

              // Дата и время
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 4),
                  Text(DateFormat('dd MMM yyyy', 'ru').format(task.dateTime)),
                  const SizedBox(width: 16),
                  const Icon(Icons.access_time, size: 16),
                  const SizedBox(width: 4),
                  Text(DateFormat('HH:mm', 'ru').format(task.dateTime)),
                ],
              ),

              const SizedBox(height: 12),

              // Кнопки действий
              Row(
                children: [
                  // Кнопка «Начать» или «Завершить»
                  if (task.status == TaskStatus.pending) ...[
                    ElevatedButton(
                      onPressed: () {
                        task.status = TaskStatus.inProcess;
                        task.save();
                      },
                      child: const Text('Начать'),
                    ),
                  ] else if (task.status == TaskStatus.inProcess) ...[
                    ElevatedButton(
                      onPressed: () {
                        task.status = TaskStatus.completed;
                        task.save();
                      },
                      child: const Text('Завершить'),
                    ),
                  ],

                  const Spacer(),

                  // Иконка удаления (для каждого статуса)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => box.delete(task.key),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
