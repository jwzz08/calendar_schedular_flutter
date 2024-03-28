import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../const/colors.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime? selectedDay;
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final defaultBoxDeco = BoxDecoration(
      //그냥 color parameter 사용하면 주말은 제외됨 - 주말은 다른 parameter 사용
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(6.0),
    );
    final defaultTextStyle = TextStyle(
      color: Colors.grey[600],
      fontWeight: FontWeight.w700,
    );

    return TableCalendar(
      locale: 'ko_KR',
      focusedDay: focusedDay,
      firstDay: DateTime(1880),
      lastDay: DateTime(3000),
      headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16.0,
          ),
      ),
      calendarStyle: CalendarStyle(
        //오늘 날짜 표기
        isTodayHighlighted: false,
        defaultDecoration: defaultBoxDeco,
        weekendDecoration: defaultBoxDeco,
        selectedDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: PRIMARY_COLOR,
            width: 1.0,
          )
        ),
        outsideDecoration: BoxDecoration(
          shape: BoxShape.rectangle
        ),
        defaultTextStyle: defaultTextStyle,
        weekendTextStyle: defaultTextStyle,
        selectedTextStyle: defaultTextStyle.copyWith(
          color: PRIMARY_COLOR,
        )
      ),
      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
        print(selectedDay);
        setState(() {
          this.selectedDay = selectedDay;
          this.focusedDay = selectedDay;
        });
      },
      selectedDayPredicate: (DateTime date) {
        if(selectedDay == null) {
          return false;
        }

        return date.year == selectedDay!.year &&
        date.month == selectedDay!.month &&
        date.day == selectedDay!.day;
      },
    );
  }
}
