import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const CalendarWidget({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    // 3 дня до и 3 дня после выбранной даты
    final start = selectedDate.subtract(const Duration(days: 3));
    final days = List.generate(7, (i) => start.add(Duration(days: i)));

    final today = DateTime.now();
    const weekdayLabels = ['Пн','Вт','Ср','Чт','Пт','Сб','Вс'];

    return Column(
      children: [
        // Header c навигацией и месяцем
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => onDateSelected(
                  selectedDate.subtract(const Duration(days: 7)),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    DateFormat('LLLL yyyy', 'ru').format(selectedDate),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => onDateSelected(
                  selectedDate.add(const Duration(days: 7)),
                ),
              ),
            ],
          ),
        ),

        // Сама «неделя» по центру
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: days.map((d) {
                final isSel = d.year == selectedDate.year
                    && d.month == selectedDate.month
                    && d.day == selectedDate.day;
                final isToday = d.year == today.year
                    && d.month == today.month
                    && d.day == today.day;

                // Цвет фона
                Color bgColor;
                if (isSel) {
                  bgColor = Colors.blue;
                } else if (isToday) {
                  bgColor = Colors.blue.withOpacity(0.2);
                } else {
                  bgColor = Colors.white;
                }

                // Цвет границы
                Color borderColor;
                if (isSel) {
                  borderColor = Colors.blue;
                } else if (isToday) {
                  borderColor = Colors.blue;
                } else {
                  borderColor = Colors.grey.shade300;
                }

                // Цвет текста
                Color textColor = isSel ? Colors.white : Colors.black87;

                return GestureDetector(
                  onTap: () => onDateSelected(d),
                  child: Container(
                    width: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          weekdayLabels[d.weekday - 1],
                          style: TextStyle(fontSize: 12, color: textColor),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${d.day}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
