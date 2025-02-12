import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/core/constants.dart';
import 'package:gd_youth_talk/src/data/models/program_model.dart';
import 'package:gd_youth_talk/src/presentation/calendar/bloc/calendarBloc/calendar_bloc.dart';
import 'package:gd_youth_talk/src/presentation/calendar/bloc/calendarBloc/calendar_event.dart';
import 'package:gd_youth_talk/src/presentation/calendar/bloc/calendarBloc/calendar_state.dart';
import 'package:gd_youth_talk/src/presentation/calendar/widgets/focusDate_avatar.dart';

// bloc
import 'package:gd_youth_talk/src/presentation/calendar/bloc/selectedProgramBloc/selected_calendar_bloc.dart';
import 'package:gd_youth_talk/src/presentation/calendar/bloc/selectedProgramBloc/selected_calendar_event.dart';
import 'package:gd_youth_talk/src/presentation/calendar/bloc/selectedProgramBloc/selected_calendar_state.dart';

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

    context.read<CalendarBloc>().add(GetAllPrograms());

    context
        .read<SelectedCalendarBloc>()
        .add(GetProgramsByDate(_focusedDay)); // 특정 날짜 선택에 따른 프로그램
  }

  @override
  Widget build(BuildContext context) {
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
            child: Text('프로그램 일정', style: theme.textTheme.labelLarge),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.0),
            child: BlocBuilder<CalendarBloc, CalendarState>(
              builder: (context, state) {
                if (state is CalendarLoadedState) {
                  return TableCalendar(
                    focusedDay: _focusedDay,
                    firstDay: DateTime(2024, 1, 1),
                    lastDay: DateTime(2030, 12, 31),
                    calendarFormat: CalendarFormat.month,
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    selectedDayPredicate: (day) => isSameDay(_focusedDay, day),
                    rowHeight: 60.0,

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

                    // eventLoader : 날짜 하단 Marker Loader
                    eventLoader: (day) {
                      // 🔹 해당 날짜와 프로그램 날짜를 비교하여 필터링
                      final normalizedDay =
                          DateTime(day.year, day.month, day.day);

                      // 오늘 이전의 날짜인 경우 마커를 표시하지 않음
                      if (normalizedDay.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
                        return [];
                      }

                      final programsForDay = state.programs
                          .where((program) =>
                              program.programDates?.any((date) =>
                                  date.year == normalizedDay.year &&
                                  date.month == normalizedDay.month &&
                                  date.day == normalizedDay.day) ??
                              false)
                          .toList();

                      return programsForDay.isNotEmpty ? programsForDay : [];
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
                      selectedBuilder: (context, day, focusDay) {
                        return Container(
                          alignment: Alignment.center,
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blueAccent),
                            child: Center(
                              child: Text(
                                '${day.day}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      markerBuilder: (context, day, events) {
                        if (events.isNotEmpty) {
                          final programsForDay = events as List<ProgramModel>;
                          return Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                programsForDay.length > 5
                                    ? 5
                                    : programsForDay.length, // 최대 5개로 제한
                                (index) {
                                  final programCategory =
                                      programsForDay[index].category != null
                                          ? CategoryTypeExtension.fromName(
                                              programsForDay[index].category!)
                                          : null;
                                  return Container(
                                    width: 7,
                                    height: 7,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: programCategory?.color ??
                                          Colors.blueAccent,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        } else {
                          return null;
                        }
                      },
                    ),

                    calendarStyle: CalendarStyle(
                      // 오늘 날짜 (Text)
                      todayTextStyle: TextStyle(
                          color: theme.scaffoldBackgroundColor,
                          fontWeight: FontWeight.bold),

                      selectedTextStyle: TextStyle(
                        color: Theme.of(context).scaffoldBackgroundColor,
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
                } else {
                  return Container();
                }
              },
            ),
          ),
          const Divider(
            height: 50.0,
            thickness: 10.0,
          ),
          Expanded(
            child: BlocBuilder<SelectedCalendarBloc, SelectedProgramState>(
                builder: (context, state) {
              if (state is SelectedProgramLoadingState) {
                print('카테고리 로딩중... shimmer 나타내기');
              } else if (state is SelectedProgramErrorState) {
                print('카테고리 Error -> 다시 재 로드 버튼 할당하기');
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 13.0, vertical: 10.0),
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
                              return Container(
                                height: 80,
                                child: CalendarTile(
                                  program: programs[index],
                                  isExpired: false,
                                  onTap: (program) {
                                    Navigator.pushNamed(
                                        context, Routes.programDetail,
                                        arguments: program.documentId);
                                  },
                                  targetDate: _focusedDay,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
              return Container();
            }),
          ),
        ],
      ),
    );
  }
}
