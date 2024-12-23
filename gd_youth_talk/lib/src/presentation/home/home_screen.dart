import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:gd_youth_talk/src/core/constants.dart';
import 'package:gd_youth_talk/src/core/routes.dart';
import 'package:gd_youth_talk/src/presentation/home/bloc/home_bloc.dart';
import 'package:gd_youth_talk/src/presentation/home/bloc/home_event.dart';
import 'package:gd_youth_talk/src/presentation/home/bloc/home_state.dart';
import 'package:gd_youth_talk/src/presentation/home/widgets/latest_program_tile.dart';
import 'package:gd_youth_talk/src/presentation/home/widgets/category_buttons.dart';
import 'package:gd_youth_talk/src/presentation/home/widgets/pageIndicator.dart';
import 'package:gd_youth_talk/src/presentation/home/widgets/program_section.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  Timer? _timer; // Timer 변수 추가

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadPrograms()); // 프로그램 로딩 실시
  }

  @override
  void dispose() {
    print('HomeScreen Dispose');
    _timer?.cancel(); // 타이머 해제
    _pageController.dispose(); // 페이지 컨트롤러 해제
    super.dispose();
  }

  // Timer initalizer
  void _initializeTimer(int itemCount) {
    _timer?.cancel();
    if (itemCount > 0) {
      _timer = Timer.periodic(Duration(seconds: 4), (timer) {
        print("타이머 실행 중... (${timer.tick}초)");
        if (_pageController.hasClients) {
          int currentPage = _pageController.page?.toInt() ?? 0;
          int nextPage = (currentPage + 1) % itemCount; // currentPage가 마지막이고, itemCount와 동일할 때 0으로 초기화(처음으로)
          _pageController.animateToPage(
            nextPage,
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  // pageControl 설정
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        leadingWidth: 200.0,
        leading: Align(
          alignment: Alignment.centerLeft, // 세로축 중앙, 가로축 왼쪽 정렬
          child: Padding(
              padding: const EdgeInsets.only(left: 13.0), // 좌측 여백 조정
              child: Image.asset('assets/logo.png')),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 13.0), // 우측 여백 조정
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.pushNamed(context, Routes.search, arguments: true);
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10),
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeLoaded) {
              // _initializeTimer(state.latestPrograms.length);
            } else if (state is HomeError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is HomeLoading) {
              print('데이터 로딩중... shimmer 나타내기');
            } else if (state is HomeError) {
              print('Home Error -> 다시 재 로드 버튼 할당하기');
            } else if (state is HomeLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // (상단)페이지 Sized Box
                        SizedBox(
                          height: 180, // 페이지 뷰 높이
                          child: PageView.builder(
                              scrollDirection: Axis.horizontal,
                              controller: _pageController,
                              physics: const BouncingScrollPhysics(),
                              itemCount: state.latestPrograms.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 13.0),
                                  child: LatestProgramTile(
                                    program: state.latestPrograms[index],
                                    onTap: (program) async {
                                      Navigator.pushNamed(
                                          context, Routes.programDetail,
                                          arguments: program);
                                    },
                                  ),
                                );
                              }),
                        ),

                        /// (상단) Page Indicator
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          // custom PageIndicator
                          child: PageIndicator(
                            pageCount: state.latestPrograms.length,
                            // 실제 프로그램 count 할당할 것
                            pageController: _pageController,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    /// 카테고리 버튼
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13.0),
                      child: Container(
                        height: 100.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,

                          // List.generate를 통한 루프 실시
                          // Category(enum)에 따른 length 처리
                          children:
                          List.generate(CategoryType.values.length, (index) {
                            final categoryType = CategoryType.values[index];
                            // label, icon 설정
                            final label = categoryType.displayName; // 카테고리의 이름
                            final color = categoryType.color; // 카테고리의 이름
                            final icon = categoryType.icon; // 카테고리의 아이콘
                            return CategoryButtons(
                              icon: icon,
                              label: label,
                              index: index,
                              color: color,
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(Routes.category, arguments: index);
                              },
                            );
                          }),
                        ),
                      ),
                    ),

                    /// Section 1. 마감 임박순
                    Section(
                      programs: state.popularPrograms,
                      sectionTitle: sectionTitle1,
                    ),

                    /// Section 2.
                    Section(
                      programs: state.upcomingPrograms,
                      sectionTitle: sectionTitle2,
                    ),

                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
