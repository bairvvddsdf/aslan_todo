import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});
  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _form = GlobalKey<FormState>();
  String _title = '';
  String _desc = '';
  DateTime _dt = DateTime.now();
  TaskStatus _status = TaskStatus.pending;
  final box = Hive.box<Task>('tasks');

  Future _pickDT() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _dt,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('ru'),
    );
    if (d == null) return;
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dt),
    );
    if (t == null) return;
    setState(() => _dt = DateTime(d.year, d.month, d.day, t.hour, t.minute));
  }

  void _save() async {
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();
    final t = Task(
      title: _title,
      description: _desc,
      dateTime: _dt,
      status: _status,
      createdAt: DateTime.now(),
    );
    await box.add(t);
    // авто-удаление, если в этом статусе >30
    final m = box.toMap().cast<dynamic, Task>().entries
        .where((e) => e.value.status == _status).toList();
    if (m.length > 30) {
      m.sort((a,b)=> a.value.createdAt.compareTo(b.value.createdAt));
      for (var e in m.take(m.length - 30)) {
        box.delete(e.key);
      }
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext c) {
    return AlertDialog(
      title: const Text('Добавить Задачу'),
      content: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Название *'),
              validator: (v) => v!.trim().isEmpty ? 'Укажите название' : null,
              onSaved: (v) => _title = v!.trim(),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Описание'),
              onSaved: (v) => _desc = v?.trim() ?? '',
            ),
            DropdownButtonFormField<TaskStatus>(
              decoration: const InputDecoration(labelText: 'Статус'),
              value: _status,
              items: const [
                DropdownMenuItem(value: TaskStatus.pending, child: Text('Ожидают')),
                DropdownMenuItem(value: TaskStatus.inProcess, child: Text('В процессе')),
                DropdownMenuItem(value: TaskStatus.completed, child: Text('Завершены')),
              ],
              onChanged: (v) => setState(() => _status = v!),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickDT,
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Дата и время'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('dd.MM.yyyy HH:mm').format(_dt)),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c), child: const Text('Отмена')),
        ElevatedButton(onPressed: _save, child: const Text('Сохранить')),
      ],
    );
  }
}
