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

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{
  final PageController _pageController = PageController();
  Timer? _timer; // Timer 변수 추가

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadPrograms());
    WidgetsBinding.instance.addObserver(this); // 화면 상태 변화 감지
  }

  // 앱 상태가 변경될 때 타이머 해제
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 현재 HomeBloc 상태 가져오기
    final homeState = context.read<HomeBloc>().state;

    if (ModalRoute.of(context)?.isCurrent ?? false) {
      if (homeState is HomeLoaded) {
        _initializeTimer(homeState.latestPrograms.length);
      }
    } else {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Timer initalizer
  void _initializeTimer(int itemCount) {
    _timer?.cancel();
    int limitedItemCount = itemCount > 4 ? 4 : itemCount; // itemCount가 4를 초과하면 4로 제한

    if (limitedItemCount > 0) {
      _timer = Timer.periodic(Duration(seconds: 4), (timer) {
        if (_pageController.hasClients) {
          int currentPage = _pageController.page?.toInt() ?? 0;
          int nextPage = (currentPage + 1) % limitedItemCount; // 4개 항목을 기준으로 순차적으로 페이지 이동
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
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.asset('assets/logo.png'),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Text('강동청년톡톡',
                  style: Theme.of(context).textTheme.labelLarge)
                ],
              )),
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
              _initializeTimer(state.latestPrograms.length);
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
              // 데이터가 없을 경우
              if (state.latestPrograms.isEmpty) {
                return Center(
                  child: Text(
                    '프로그램 데이터가 존재하지 않습니다.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              itemCount: state.latestPrograms.length > 4 ? 4 : state.latestPrograms.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 13.0),
                                  child: LatestProgramTile(
                                    program: state.latestPrograms[index],
                                    onTap: (program) {
                                      Navigator.pushNamed(
                                          context, Routes.programDetail,
                                          arguments: program.documentId);
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
                            pageCount: state.latestPrograms.length > 4 ? 4 : state.latestPrograms.length,
                            // 실제 프로그램 count 할당할 것
                            pageController: _pageController,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 20,
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

                    const SizedBox(
                      height: 30,
                    ),

                    /// Section 1. 마감 임박순
                    state.popularPrograms.isEmpty
                        ? SizedBox.shrink()
                        : Section(
                            programs: state.popularPrograms,
                            sectionTitle: sectionTitle1,
                          ),

                    /// Section 2.
                    state.upcomingPrograms.isEmpty
                        ? SizedBox.shrink()
                        : Section(
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
