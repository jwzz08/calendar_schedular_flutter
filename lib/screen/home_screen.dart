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
              return ScheduleBottomSheet(
                selectedDate: selectedDay,
              );
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
              stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
              builder: (context, snapshot) {
                print(snapshot.data);

                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator());
                }

                //데이터가 있는데(not null) 들어온 데이터가 길이가 0일 때(리스트에 값이 없을 때)
                if(snapshot.hasData && snapshot.data!.isEmpty){
                  return Center(
                    child: Text('No Schedule'),
                  );
                }

                return ListView.separated(
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 8.0,
                      );
                    },
                    itemBuilder: (context, index) {
                      final schedule = snapshot.data![index];

                      return ScheduleCard(
                          startTime: schedule.startTime,
                          endTime: schedule.endTime,
                          content: schedule.content,
                          color: Colors.red);
                    });
              })),
    );
  }
}
