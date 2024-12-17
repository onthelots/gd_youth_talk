import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/core/constants.dart';
import 'package:gd_youth_talk/src/core/routes.dart';
import 'package:gd_youth_talk/src/presentation/home/bloc/home_bloc.dart';
import 'package:gd_youth_talk/src/presentation/home/bloc/home_event.dart';
import 'package:gd_youth_talk/src/presentation/home/bloc/home_state.dart';
import 'package:gd_youth_talk/src/presentation/home/widgets/latest_program_tile.dart';
import 'package:gd_youth_talk/src/presentation/home/widgets/category_buttons.dart';
import 'package:gd_youth_talk/src/presentation/home/widgets/pageIndicator.dart';

class HomeScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  // pageControl 설정
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(GetLatestProgramsEvent());
    });

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoadingState) {
          return CircularProgressIndicator();
        } else if (state is HomeLoadedState) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              scrolledUnderElevation: 0,
              leadingWidth: 200.0,
              leading: const Align(
                alignment: Alignment.centerLeft, // 세로축 중앙, 가로축 왼쪽 정렬
                child: Padding(
                    padding: const EdgeInsets.only(left: 13.0), // 좌측 여백 조정
                    child: Icon(Icons.app_registration)),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.only(top: 5),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// (상단)페이지 Sized Box
                    SizedBox(
                      height: 200, // 페이지 뷰 높이
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: _pageController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.programs.length,
                        itemBuilder: (context, index) {
                          return LatestProgramTile(
                            program: state.programs[index],
                            onTap: (program) {
                              Navigator.pushNamed(
                                  context,
                                  Routes.programDetail,
                                  arguments: program);
                            },
                          ); // PageContent에 전달
                        },
                      ),
                    ),

                    /// (상단) Page Indicator
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      // custom PageIndicator
                      child: PageIndicator(
                        pageCount: state.programs.length,
                        // 실제 프로그램 count 할당할 것
                        pageController: _pageController,
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    /// (중앙) 카테고리 버튼
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13.0),
                      child: Container(
                        height: 100.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,

                          // List.generate를 통한 루프 실시
                          // Category(enum)에 따른 length 처리
                          children: List.generate(CategoryType.values.length,
                              (index) {
                            final categoryType = CategoryType.values[index];
                            // label, icon 설정
                            final label =
                                categoryType.displayName; // 카테고리의 이름
                            final icon = categoryType.icon; // 카테고리의 아이콘
                            return CategoryButtons(
                              icon: icon,
                              label: label,
                              index: index,
                              onTap: () {
                                Navigator.of(context).pushNamed(Routes.category, arguments: index);
                              },
                            );
                          }),
                        ),
                      ),
                    ),
                    // Section별 리스트

                    const SizedBox(
                      height: 20,
                    ),

                    /// Section
                    // for (var programs in programsList)
                    //   Section(programs: programs)
                  ],
                ),
              ),
            ),
          );
        } else if (state is HomeErrorState) {
          return Text('Error: ${state.message}');
        } else {
          return Center(child: Text('무슨 상태인데..?'));
        }
      },
    );
  }
}
