import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(); // pageControl 설정
  int _currentPage = 0; // 현재 page

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
            // 페이지 인디케이터
            SizedBox(
              height: 200, // 페이지 뷰 높이
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildPageContent("Page 1", Colors.blue),
                  _buildPageContent("Page 2", Colors.green),
                  _buildPageContent("Page 3", Colors.orange),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PageIndicator(currentPage: _currentPage, pageCount: 3),
            ),
            // 버튼 4개
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildButton(Icons.home, "Home"),
                  _buildButton(Icons.search, "Search"),
                  _buildButton(Icons.notifications, "Alerts"),
                  _buildButton(Icons.person, "Profile"),
                ],
              ),
            ),
            // Section별 리스트
            Section(
              sectionText: "Photo Gallery",
              programTitle: 'Program Title',
              color: Colors.grey,
              itemCount: 5,
              imageUrls: [
                'https://via.placeholder.com/300',
                'https://via.placeholder.com/150',
                'https://via.placeholder.com/150',
                'https://via.placeholder.com/150',
                'https://via.placeholder.com/150',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(String text, Color color) {
    return Container(
      color: color,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Positioned(
            child: Container(
              width: 150,
              height: 150,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  // children: [
  //   // 첫 번째 Container는 Expanded로 감싸서 여유 공간을 차지하도록 함
  //   Expanded(
  //     child: Container(
  //       height: 150,
  //       child: Column(
  //         children: [
  //           // FilledButton은 이미지의 수직 중앙에 위치
  //           Align(
  //             alignment: Alignment.topLeft,
  //             child: FilledButton(
  //               onPressed: () {},
  //               style: ButtonStyle(
  //                 padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
  //                     EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
  //                 minimumSize: WidgetStateProperty.all<Size>(Size.zero),
  //               ),
  //               child: Text('문화&취미'),
  //             ),
  //           ),
  //
  //           Align(
  //             alignment: Alignment.centerLeft,
  //             child: Text(
  //               '<Upcycling Week_플라스틱> 참여자 추가모집',
  //               overflow: TextOverflow.ellipsis,
  //               maxLines: 2, // max line
  //               style: Theme.of(context).textTheme.bodyLarge,
  //             ),
  //           ),
  //
  //           // 위치 정보 텍스트, 하단에 고정
  //
  //           Align(
  //             alignment: Alignment.bottomLeft,
  //             child: Text(
  //               '11/24(일) ~ 12/2(월) 14:00',
  //               overflow: TextOverflow.ellipsis,
  //               maxLines: 1, // max line
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   ),
  //
  //   Container(
  //     color: Colors.red,
  //     height: 150,
  //     width: 150,
  //   ),
  // ],


  Widget _buildButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 32),
        SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  PageIndicator({required this.currentPage, required this.pageCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: currentPage == index ? Colors.blue : Colors.grey,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}

class Section extends StatelessWidget {
  final String sectionText;
  final String programTitle;
  final Color color;
  final int itemCount;
  final List<String> imageUrls; // 이미지 URL 리스트

  Section({
    required this.sectionText,
    required this.programTitle,
    required this.color,
    required this.itemCount,
    required this.imageUrls,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              sectionText,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),

          // ListView
          SizedBox(
            height: 165,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: itemCount, // item 갯수
              itemBuilder: (context, index) {
                return Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 150,
                  margin: EdgeInsets.all(8),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            imageUrls[index], // URL로 이미지 로드
                            width: 120, // 이미지 크기 조정
                            height: 120,
                            fit: BoxFit.cover, // 이미지 크기에 맞게 자르기
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          programTitle,
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      ],
                    ),
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
