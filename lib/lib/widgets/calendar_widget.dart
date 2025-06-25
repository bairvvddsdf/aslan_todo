import 'package:flutter/material.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  const CalendarWidget({
    required this.selectedDate,
    required this.onDateSelected,
    super.key,
  });
  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}
class _CalendarWidgetState extends State<CalendarWidget> {
  final ScrollController _ctrl = ScrollController();
  final double _w = 60;
  late final List<DateTime> _dates;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _dates = List.generate(365, (i) => DateTime(today.year, today.month, today.day)
        .subtract(Duration(days: 183))
        .add(Duration(days: i)));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final idx = _dates.indexWhere((d) =>
      d.year == today.year && d.month == today.month && d.day == today.day);
      if (idx >= 0) _ctrl.jumpTo(idx * _w);
    });
  }

  String _wd(int w) => const ['Пн','Вт','Ср','Чт','Пт','Сб','Вс'][w-1];

  @override
  Widget build(BuildContext c) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        controller: _ctrl,
        scrollDirection: Axis.horizontal,
        itemCount: _dates.length,
        itemBuilder: (_, i) {
          final d = _dates[i];
          final sel = d.year == widget.selectedDate.year
              && d.month == widget.selectedDate.month
              && d.day == widget.selectedDate.day;
          return GestureDetector(
            onTap: () => widget.onDateSelected(d),
            child: Container(
              width: _w,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              decoration: BoxDecoration(
                color: sel ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_wd(d.weekday), style: TextStyle(color: sel ? Colors.white : null)),
                  const SizedBox(height: 4),
                  Text('${d.day}', style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold,
                    color: sel ? Colors.white : null,
                  )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
