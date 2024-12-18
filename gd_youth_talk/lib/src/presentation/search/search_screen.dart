import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/core/constants.dart';
import 'package:gd_youth_talk/src/core/routes.dart';
import 'package:gd_youth_talk/src/presentation/search/bloc/search_bloc.dart';
import 'package:gd_youth_talk/src/presentation/search/bloc/search_event.dart';
import 'package:gd_youth_talk/src/presentation/search/bloc/search_state.dart';
import 'package:gd_youth_talk/src/presentation/search/widgets/search_result_placeholder.dart';
import 'package:gd_youth_talk/src/presentation/search/widgets/search_result_tile.dart';

class SearchScreen extends StatefulWidget {
  final bool isHomeScreenPushed;

  SearchScreen({required this.isHomeScreenPushed});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<SearchBloc>().add(SearchQueryProgramsEvent(query: "")); // 초기화 설정
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: widget.isHomeScreenPushed ? Text('검색') : null,
        leadingWidth: widget.isHomeScreenPushed ? null : 200,
        leading: widget.isHomeScreenPushed
            ? null
            : Align(
                alignment: Alignment.centerLeft, // 세로축 중앙, 가로축 왼쪽 정렬
                child: Padding(
                  padding: const EdgeInsets.only(left: 13.0), // 좌측 여백 조정
                  child: Text('검색',
                      style: Theme.of(context).textTheme.displayMedium),
                ),
              ),
      ),
      body: Column(
        children: [
          // 검색창 부분은 BlocBuilder 외부에 둡니다.
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
                controller: _searchController, // 컨트롤러 연결
                focusNode: _focusNode, // 포커스 노드 추가
                onChanged: (value) {
                  context.read<SearchBloc>().add(
                    SearchQueryProgramsEvent(query: value),
                  );
                },
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
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          // BlocBuilder 사용하여 하단 리스트만 리빌드
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchLoadingState) {
                return Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (state is SearchLoadedState) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: state.programs.isEmpty
                        ? Center(child: SearchResultPlaceholder())
                        : ListView.builder(
                      itemCount: state.programs.length,
                      itemBuilder: (context, index) {
                        final program = state.programs[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: SearchResultTile(
                            program: program,
                            query: _searchController.text, // 검색어 전달
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
                );
              } else if (state is SearchErrorState) {
                return Expanded(
                  child: Center(child: Text('Error: ${state.message}')),
                );
              } else {
                return Expanded(
                  child: Center(child: Text('아무 데이터도 없습니다.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
