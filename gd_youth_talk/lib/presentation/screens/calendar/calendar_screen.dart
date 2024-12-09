import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gd_youth_talk/app/routes.dart';
import 'package:gd_youth_talk/app/dummy_data.dart';
import 'package:gd_youth_talk/presentation/widgets/calendar_tile.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

  // 더미데이터
  final List<Programs> programsList = programData.entries.map((entry) {
    return Programs.fromMap(entry.key, entry.value as Map<String, dynamic>);
  }).toList();

  // 날짜와 프로그램 데이터
  late Map<DateTime, List<Program>> _events;

  // 현재 선택된 날짜 (오늘)
  late DateTime _focusedDay;

  // 선택한  날짜
  late DateTime _selectedDay;
  List<Program> _selectedPrograms = []; // 선택된 날짜의 프로그램 목록

  @override
  void initState() {
    super.initState();

    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _events = _initializeEvents(); // 초기화 시 _events를 설정합니다.
    _updateSelectedPrograms(_selectedDay);
  }

  Map<DateTime, List<Program>> _initializeEvents() {
    Map<DateTime, List<Program>> events = {};

    // programsList에서 각 프로그램을 날짜별로 매핑
    for (var programs in programsList) {
      for (var program in programs.items) {
        DateTime programDate = program.date;

        // 프로그램 날짜를 기준으로 프로그램을 추가
        if (events[programDate] == null) {
          events[programDate] = [];
        }
        events[programDate]!.add(program);
      }
    }
    return events;
  }

  void _updateSelectedPrograms(DateTime day) {
    setState(() {
      _selectedPrograms = _events[day] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.0),
              child: TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime(2023, 1, 1),
                lastDay: DateTime(2030, 12, 31),
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.monday,
                eventLoader: (day) => _events[day] ?? [],
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _updateSelectedPrograms(selectedDay);
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                  _updateSelectedPrograms(focusedDay);
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: theme.primaryColor,
                    shape: BoxShape.circle,
                  ),

                  selectedDecoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),

                  markerDecoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),
            ),

            Divider(
              height: 30.0,
              thickness: 5.0,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${_focusedDay.year}년 ${_focusedDay.month}월 ${_focusedDay.day}일의 프로그램",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),

            Expanded(
              child: _selectedPrograms.isEmpty
                  ? Center(
                child: Text(
                  '선택된 날짜에 진행되는 프로그램이 없습니다.',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              )
                  : ListView.builder(
                itemCount: _selectedPrograms.length,
                itemBuilder: (context, index) {
                  return CalendarTile(program: _selectedPrograms[index], onTap: (program) {
                    Navigator.pushNamed(context, Routes.programDetail, arguments: program);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
