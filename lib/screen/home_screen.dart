import 'package:calendar_scheduler/component/calendar.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //timezone 관련 버그 조심!!!
  //2024-04-18 00:00:00.000Z
  //뒤에 z는 utc +0 기준이라 여기에 맞춰줌
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: renderFloatingActionButton(),
        body: SafeArea(
          child: Column(
            children: [
              Calendar(
                selectedDay: selectedDay,
                focusedDay: focusedDay,
                onDaySelected: onDaySelected,
              ),
              SizedBox(
                height: 8.0,
              ),
              TodayBanner(selectedDay: selectedDay, scheduleCount: 3),
              SizedBox(
                height: 8.0,
              ),
              _ScheduleList(selectedDate: selectedDay),
            ],
          ),
        ));
  }

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (_) {
              return ScheduleBottomSheet(selectedDate: selectedDay,);
            },
            //modalbottomsheet가 더 위로 올라오게 해줌
            isScrollControlled: true);
      },
      backgroundColor: PRIMARY_COLOR,
      child: Icon(Icons.add),
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    print(selectedDay);
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }
}

class _ScheduleList extends StatelessWidget {
  final DateTime selectedDate;

  const _ScheduleList({required this.selectedDate, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: StreamBuilder<List<Schedule>>(
            stream: GetIt.I<LocalDatabase>().watchSchedules(),
            builder: (context, snapshot) {
              print('---------original data------------');
              print(snapshot.data);

              List<Schedule> schedules = [];

              if(snapshot.hasData) {
                schedules = snapshot.data!.where((element) => element.date == selectedDate).toList();

                print('---------------filtered data---------------');
                print(selectedDate);
                print(schedules);
              }

              return ListView.separated(
                  itemCount: 10,
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 8.0,
                    );
                  },
                  itemBuilder: (context, index) {
                    return ScheduleCard(
                        startTime: 12,
                        endTime: 14,
                        content: '프로그래밍 공부하기',
                        color: Colors.red);
                  });
            }
          )),
    );
  }
}
