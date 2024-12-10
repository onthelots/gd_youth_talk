import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/app/routes.dart';
import 'package:gd_youth_talk/core/constants.dart';
import 'package:gd_youth_talk/presentation/screens/home/widgets/program_section.dart';
import 'package:gd_youth_talk/presentation/widgets/pageIndicator.dart';
import 'package:gd_youth_talk/presentation/screens/home/widgets/category_buttons.dart';
import 'package:gd_youth_talk/presentation/screens/home/widgets/program_page_contents.dart';
import 'package:gd_youth_talk/app/dummy_data.dart';

class HomeScreen extends StatelessWidget {
  final PageController _pageController = PageController();
  final List<Programs> programsList = programData.entries.map((entry) {
    return Programs.fromMap(entry.key, entry.value as Map<String, dynamic>);
  }).toList();

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
            child: Icon(Icons.add)
          ),
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
                  itemCount: 4, // 4개만 랜덤으로 표시
                  itemBuilder: (context, index) {
                    // 모든 프로그램 데이터를 가져옵니다.
                    final allPrograms = <Program>[];
        
                    programData.forEach((categoryName, categoryData) {
                      final programs = Programs.fromMap(categoryName, categoryData);
                      allPrograms.addAll(programs.items); // 각 카테고리의 아이템들을 추가
                    });
        
                    // 4개의 랜덤 프로그램 아이템 선택
                    final randomPrograms = List.generate(4, (i) {
                      return allPrograms[Random().nextInt(allPrograms.length)];
                    });
        
                    final program = randomPrograms[index]; // 랜덤으로 선택된 프로그램

                    return PageContent(
                      program: program,
                      onTap: (program) {
                        Navigator.pushNamed(context, Routes.programDetail, arguments: program);
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
                  pageCount: 4, // 실제 프로그램 count 할당할 것
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
                    children: List.generate(CategoryType.values.length, (index) {
                      final categoryType = CategoryType.values[index]; // index에 따른 CategoryType 할당
                      // label, icon 설정
                      final label = categoryType.displayName; // 확장된 displayName 사용
                      final icon = categoryType.icon; // 확장된 icon 사용
                      return CategoryButtons(
                        icon: icon,
                        label: label,
                        index: index,
                        onTap: () {
                          Navigator.pushNamed(context, Routes.category, arguments: index);
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
              for (var programs in programsList)
                Section(programs: programs)
            ],
          ),
        ),
      ),
    );
  }
}
