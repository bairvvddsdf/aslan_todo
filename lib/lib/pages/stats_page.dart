import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/task.dart';
import '../widgets/task_card.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});
  @override
  Widget build(BuildContext ctx) {
    final box = Hive.box<Task>('tasks');
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Ожидают'),
              Tab(text: 'В процессе'),
              Tab(text: 'Завершены'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: TaskStatus.values.map((status) {
                final list = box.values.where((t) => t.status == status).toList();
                if (list.isEmpty) {
                  final msg = {
                    TaskStatus.pending: 'Нет ожидающих задач',
                    TaskStatus.inProcess: 'Нет задач в процессе',
                    TaskStatus.completed: 'Нет завершённых задач',
                  }[status]!;
                  return Center(child: Text(msg));
                }
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) => TaskCard(task: list[i]),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
