import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// bloc
import 'package:gd_youth_talk/src/presentation/calendar/bloc/selectedProgramBloc/selected_calendar_bloc.dart';
import 'package:gd_youth_talk/src/presentation/calendar/bloc/selectedProgramBloc/selected_calendar_event.dart';
import 'package:gd_youth_talk/src/presentation/calendar/bloc/selectedProgramBloc/selected_calendar_state.dart';

import 'package:gd_youth_talk/src/presentation/calendar/bloc/calendarBloc/calendar_bloc.dart';
import 'package:gd_youth_talk/src/presentation/calendar/bloc/calendarBloc/calendar_event.dart';
import 'package:gd_youth_talk/src/presentation/calendar/bloc/calendarBloc/calendar_state.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:gd_youth_talk/src/core/routes.dart';
import 'widgets/calendar_tile.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

  // 포커싱 날짜
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CalendarBloc>().add(GetProgramsGroupedByDate()); // 전체 프로그램 (날짜 : 프로그램 매핑)
      context.read<SelectedCalendarBloc>().add(GetProgramsByDate(_focusedDay)); // 특정 날짜 선택에 따른 프로그램
    });

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        leadingWidth: 200.0,
        leading: Align(
          alignment: Alignment.centerLeft, // 세로축 중앙, 가로축 왼쪽 정렬
          child: Padding(
              padding: const EdgeInsets.only(left: 13.0), // 좌측 여백 조정
              child: Text(
                  '프로그램 일정',
                  style: theme.textTheme.displayMedium
              ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.0),
            child: BlocBuilder<CalendarBloc, CalendarState>(
              builder: (context, state) {
                return TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime(2024, 1, 1),
                  lastDay: DateTime(2030, 12, 31),
                  calendarFormat: CalendarFormat.month,
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  selectedDayPredicate: (day) => isSameDay(_focusedDay, day),

                  // eventLoader : 날짜 하단 이벤트 나타내는 작은 버튼 (day 파라미터를 기반으로 할당)
                  eventLoader: (day) {
                    if (state is CalendarLoadedState) {
                      // 인자인 'day'의 시간 정보를 00:00:00으로 설정하여 비교
                      final normalizedDay =
                          DateTime(day.year, day.month, day.day);

                      // normalizedDay를 사용하여 비교
                      final programsForDay = state.programs[normalizedDay];
                      return programsForDay ?? [];
                    }
                    return [];
                  },

                  // 날짜 선택
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                    context
                        .read<SelectedCalendarBloc>()
                        .add(GetProgramsByDate(_focusedDay));
                  },

                  // 페이지가 넘어갈 경우, 포커싱 할 날짜 (일단 현재날짜로 유지할 것)
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },

                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(
                        color: theme.primaryColor.withOpacity(0.5),
                        width: 2.0,
                      ),
                      shape: BoxShape.circle,
                    ),

                    // 선택
                    selectedDecoration: BoxDecoration(
                      color: theme.primaryColor,
                      shape: BoxShape.circle,
                    ),

                    // 마커
                    markerDecoration: BoxDecoration(
                      color: theme.highlightColor,
                      shape: BoxShape.circle,
                    ),
                  ),

                  // 요일 높이
                  daysOfWeekHeight: 22.0,

                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                );
              },
            ),
          ),
          const Divider(
            height: 30.0,
            thickness: 10.0,
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
            child: BlocBuilder<SelectedCalendarBloc, SelectedProgramState>(
              builder: (context, state) {
                if (state is SelectedProgramLoadingState) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is SelectedProgramLoadedState) {
                  final programs = state.selectedPrograms;
                  if (programs.isEmpty) {
                    return Center(
                      child: Text(
                        '선택된 날짜에 진행되는 프로그램이 없습니다.',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: programs.length,
                      itemBuilder: (context, index) {
                        return CalendarTile(
                          program: programs[index],
                          onTap: (program) {
                            Navigator.pushNamed(
                              context,
                              Routes.programDetail,
                              arguments: program,
                            );
                          },
                        );
                      },
                    );
                  }
                } else if (state is SelectedProgramErrorState) {
                  return Center(
                    child: Text(
                      '오류가 발생했습니다: ${state.message}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
