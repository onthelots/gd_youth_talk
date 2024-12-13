import 'package:flutter/material.dart';
import 'package:gd_youth_talk/app/routes.dart';
import 'package:gd_youth_talk/data/models/program_model.dart';
import 'package:gd_youth_talk/presentation/screens/search/widgets/search_result_tile.dart';
import 'package:gd_youth_talk/presentation/screens/search/widgets/search_result_placeholder.dart';
import 'package:gd_youth_talk/core/constants.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  List<ProgramModel> searchQueryResult = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    searchQuery = "";
    searchQueryResult = [];
  }

  @override
  void dispose() {
    // 검색 결과와 검색 문자열 초기화
    searchQuery = "";
    searchQueryResult = [];
    super.dispose();
  }

  void _searchPrograms(String query) {
    final queryLower = query.toLowerCase();
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        searchQueryResult = [];
        // } else {
        //   searchQueryResult = programsList
        //       .expand((programs) => programs.items)
        //       .where((program) =>
        //   program.title.toLowerCase().contains(queryLower) ||
        //       program.subtitle.toLowerCase().contains(queryLower))
        //       .toList();
        // }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        leadingWidth: 200.0,
        leading: Align(
          alignment: Alignment.centerLeft, // 세로축 중앙, 가로축 왼쪽 정렬
          child: Padding(
            padding: const EdgeInsets.only(left: 13.0), // 좌측 여백 조정
            child: Text(
                '검색',
                style: Theme.of(context).textTheme.displayMedium
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  onChanged: _searchPrograms,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: '관심 키워드, 프로그램 명, 카테고리 찾기',
                    hintStyle: theme.textTheme.bodyMedium,
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDarkMode
                          ? AppColors.darkIcon
                          : AppColors.lightIcon,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: searchQueryResult.isEmpty && searchQuery.isEmpty
                    ? Center(
                        child: SearchResultPlaceholder(),
                      )
                    : ListView.builder(
                  itemCount: searchQueryResult.length,
                  itemBuilder: (context, index) {
                    final program = searchQueryResult[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: SearchResultTile(
                        program: program,
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
            ),
          ],
        ),
      ),
    );
  }
}
