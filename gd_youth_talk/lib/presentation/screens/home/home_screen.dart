import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/app/routes.dart';
import 'package:gd_youth_talk/presentation/widgets/program_section.dart';
import 'package:gd_youth_talk/presentation/widgets/pageIndicator.dart';
import 'package:gd_youth_talk/app/dummy_data.dart';

class HomeScreen extends StatelessWidget {
  final PageController _pageController = PageController();
  final categories = parseCategoryData(categoryData);

  // button Data 
  final List<Map<String, dynamic>> buttonData = [
    {'icon': Icons.volunteer_activism, 'label': "건강&웰빙"},
    {'icon': Icons.psychology, 'label': "자기계발"},
    {'icon': Icons.palette, 'label': "문화&취미"},
    {'icon': Icons.local_library, 'label': "강연&포럼"},
  ];
  
  // pageControl 설정
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.home), // 로고
        title: Text('My App'),
        actions: [
          Icon(Icons.settings), // Trailing 아이콘
        ],
      ),
      body: SingleChildScrollView(
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
                itemCount: 5,
                itemBuilder: (context, index) {
                  // 랜덤으로 카테고리 5개 뽑기
                  final random = Random();
                  final randomIndex = random.nextInt(categories.length);  // 랜덤 인덱스
                  final category = categories[randomIndex]; // 랜덤 카테고리 가져오기

                  // 해당 카테고리의 첫 번째 아이템을 사용
                  final item = category.items[0];
                  return _buildPageContent(item, context);
                },
              ),
            ),

            /// (상단) Page Indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              // custom PageIndicator
              child: PageIndicator(
                pageCount: 5, // 실제 프로그램 count 할당할 것
                pageController: _pageController,
              ),
            ),

            SizedBox(
              height: 20,
            ),

            /// (중앙) 카테고리 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              child: Container(
                height: 100.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,

                  // List.generate를 통한 루프 실시
                  children: List.generate(categories.length, (index) {
                    final button = buttonData[index]; // 버튼 데이터 매칭
                    return _buildButton(
                      button['icon'], // 아이콘
                      button['label'], // 레이블
                      context,
                      index,
                    );
                  }),
                ),
              ),
            ),
            // Section별 리스트

            SizedBox(
              height: 20,
            ),

            /// Section
            for (var category in categories)
              Section(category: category)
          ],
        ),
      ),
    );
  }

  /// Widgets 1. buildPageContent
  Widget _buildPageContent(CategoryItem item, BuildContext context) {
    return Container(
      color: Colors.grey,
      width: double.infinity, // 페이지 뷰 너비
      height: double.infinity, // 페이지 뷰 높이
      child: Stack(
        alignment: Alignment.center, // Stack 전체 중앙정렬
        children: [
          // 첫 번째 Container (150x150 크기, 오른쪽 중앙에 위치)
          Positioned(
            right: 0,
            child: Container(
              width: 200,
              height: 200,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    item.thumbnailUrl,
                    width: 180, // 이미지 크기 조정
                    height: 180,
                    fit: BoxFit.cover, // 이미지 크기에 맞게 자르기
                  ),
                ),
                // 이미지 할당하기 (150 x 150 사이즈로)
              ),
            ),
          ),

          Positioned(
            left: 10,
            child: Container(
              width: MediaQuery.of(context).size.width - 200, // 현재 페이지 너비에서 이미지 Container Width 200(고정값) 뺀 값
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FilledButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                      minimumSize: WidgetStateProperty.all<Size>(Size.zero),
                    ),
                    child: Text(item.title),
                  ),

                  Text(
                    item.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2, // max line
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  // 위치 정보 텍스트, 하단에 고정
                  Text(
                    item.date.timeZoneName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1, // max line
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Widgets 2. buttons
  Widget _buildButton(
      IconData icon,
      String label,
      BuildContext context,
      int index,
      ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: IconButton(
            icon: Icon(
              icon,
              size: 25,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Navigator.pushNamed(context, Routes.category, arguments: index);
            },
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
