import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/core/constants.dart';
import 'package:gd_youth_talk/src/presentation/calendar/widgets/focusDate_avatar.dart';
import 'package:intl/intl.dart';

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
  const CalendarScreen({super.key});

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
      context.read<CalendarBloc>().add(
          GetProgramsGroupedByDate()); // 전체 프로그램 (날짜 : 프로그램 매핑)
      context.read<SelectedCalendarBloc>().add(
          GetProgramsByDate(_focusedDay)); // 특정 날짜 선택에 따른 프로그램
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

                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      fontWeight: FontWeight.bold, // 평일 요일 텍스트 굵게
                      fontSize: 14,
                    ),
                    weekendStyle: TextStyle(
                      fontWeight: FontWeight.bold, // 주말 요일 텍스트 굵게
                      fontSize: 14,
                    ),
                  ),

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

                  calendarBuilders: CalendarBuilders(
                    todayBuilder: (context, day, focusedDay) {
                      return Container(
                        alignment: Alignment.center,
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },

                    selectedBuilder: (context, day, focusedDay) {
                      return Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.blueAccent, // 원하는 색상으로 변경
                          shape: BoxShape.circle, // 원형으로 설정
                        ),
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    markerBuilder: (context, day, events) {
                      bool isSelectedDay = day == _focusedDay;

                      return events.isNotEmpty
                          ? Container(
                        width: 18,
                        height: 18,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelectedDay ? Colors.black87 : Colors
                              .black12,
                        ),
                        child: Text(
                          '${events.length}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      )
                          : null;
                    },
                  ),

                  calendarStyle: CalendarStyle(
                    markerSize: 10.0,
                    markersAlignment: Alignment.bottomRight,

                    markerDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),

                    // 오늘 날짜 (Text)
                    todayTextStyle: TextStyle(
                        color: theme.scaffoldBackgroundColor,
                        fontWeight: FontWeight.bold
                    ),

                    selectedTextStyle: TextStyle(
                      color: Theme
                          .of(context)
                          .scaffoldBackgroundColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  // 요일 높이
                  daysOfWeekHeight: 40.0,

                  headerStyle: const HeaderStyle(
                    titleTextStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
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
                      '선택한 날짜에 진행되는 프로그램이 없습니다.',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FocusDateAvatar(focusedDay: _focusedDay),
                        const SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: programs.length,
                            itemBuilder: (context, index) {
                              // 프로그램 만료여부 확인
                              final bool isExpired = programs[index].programEndDate?.isBefore(DateTime.now()) ?? false;
                              return Container(
                                height: 80,
                                child: CalendarTile(
                                  program: programs[index],
                                  isExpired: isExpired,
                                  onTap: (program) {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.programDetail,
                                      arguments: program,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              } else if (state is SelectedProgramErrorState) {
                return Center();
              } else {
                return SizedBox.shrink();
              }
            }),
          ),
        ],
      ),
    );
  }
}
