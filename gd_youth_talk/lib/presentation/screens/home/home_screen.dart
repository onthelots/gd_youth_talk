import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/app/routes.dart';
import 'package:gd_youth_talk/data/sources/programs_datasource.dart';
import 'package:gd_youth_talk/domain/repositories/program_repository.dart';
import 'package:gd_youth_talk/presentation/bloc/program_bloc.dart';
import 'package:gd_youth_talk/domain/usecases/program_usecase.dart';
import 'package:gd_youth_talk/presentation/screens/home/widgets/program_section.dart';
import 'package:gd_youth_talk/presentation/widgets/pageIndicator.dart';
import 'package:gd_youth_talk/presentation/screens/home/widgets/category_buttons.dart';
import 'package:gd_youth_talk/presentation/screens/home/widgets/program_page_contents.dart';

class HomeScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  // pageControl 설정
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProgramBloc(ProgramUseCase(ProgramRepository(ProgramDataSource(FirebaseFirestore.instance))))
        ..add(GetLatestProgramsEvent())
        ..add(LoadProgramsByCategories()),
      child: BlocBuilder<ProgramBloc, ProgramState>(
        builder: (context, state) {
          if (state is ProgramLoadingState) {
            return CircularProgressIndicator();
          } else if (state is ProgramLoadedState) {
            print("Programs loaded: ${state.latestPrograms}");
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  state.latestPrograms!.isNotEmpty ? state.latestPrograms?.first.title ?? "없음" : "없음",
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                scrolledUnderElevation: 0,
                leadingWidth: 200.0,
                leading: const Align(
                  alignment: Alignment.centerLeft, // 세로축 중앙, 가로축 왼쪽 정렬
                  child: Padding(
                      padding: const EdgeInsets.only(left: 13.0), // 좌측 여백 조정
                      child: Icon(Icons.add)),
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
                          itemCount: state.latestPrograms.length,
                          // 4개만 랜덤으로 표시
                          itemBuilder: (context, index) {
                            return Text(state.latestPrograms.first.title ?? "");
                            // return PageContent(
                            //   program: state.latestPrograms.first,
                            //   onTap: (program) {
                            //     Navigator.pushNamed(
                            //         context, Routes.programDetail,
                            //         arguments: program);
                            //   },
                            // ); // PageContent에 전달
                          },
                        ),
                      ),

                      /// (상단) Page Indicator
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        // custom PageIndicator
                        child: PageIndicator(
                          pageCount: 4, // 실제 프로그램 count 할당할 것
                          pageController: _pageController,
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      /// (중앙) 카테고리 버튼
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 13.0),
                      //   child: Container(
                      //     height: 100.0,
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //
                      //       // List.generate를 통한 루프 실시
                      //       // Category(enum)에 따른 length 처리
                      //       children: List.generate(CategoryType.values.length,
                      //           (index) {
                      //         final categoryType = CategoryType
                      //             .values[index]; // index에 따른 CategoryType 할당
                      //         // label, icon 설정
                      //         final label =
                      //             categoryType.displayName; // 확장된 displayName 사용
                      //         final icon = categoryType.icon; // 확장된 icon 사용
                      //         return CategoryButtons(
                      //           icon: icon,
                      //           label: label,
                      //           index: index,
                      //           onTap: () {
                      //             Navigator.pushNamed(context, Routes.category,
                      //                 arguments: index);
                      //           },
                      //         );
                      //       }),
                      //     ),
                      //   ),
                      // ),
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
          } else if (state is ProgramErrorState) {
            return Text('Error: ${state.message}');
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
