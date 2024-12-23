import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/core/constants.dart';
import 'package:gd_youth_talk/src/core/routes.dart';
import 'package:gd_youth_talk/src/core/theme.dart';
import 'package:gd_youth_talk/src/presentation/category/bloc/category_event.dart';
import 'package:gd_youth_talk/src/presentation/category/widgets/category_tile.dart';
import 'bloc/category_bloc.dart';
import 'bloc/category_state.dart';

class CategoryScreen extends StatefulWidget {
  int selectedIndex;

  CategoryScreen({required this.selectedIndex});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // 프로그램 로딩 실시
    context.read<CategoryBloc>().add(LoadCategoryEvent(
        CategoryType.values[widget.selectedIndex].displayName));

    // tabController 실행
    _tabController = TabController(
      length: CategoryType.values.length,
      vsync: this,
      initialIndex: widget.selectedIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          '카테고리',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            width: double.infinity,
            child: TabBar(
              isScrollable: false,
              labelStyle: Theme.of(context).textTheme.labelMedium,
              unselectedLabelStyle:
                  Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.unselectedLabelColor(context),
                      ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Theme.of(context).primaryColor,
              indicatorWeight: 1.0,
              controller: _tabController,
              tabs: [
                for (final category in CategoryType.values)
                  Tab(text: category.displayName)
              ],
              onTap: (index) {

                // 인덱스 변경 시,
                context.read<CategoryBloc>().add(
                    LoadCategoryEvent(CategoryType.values[index].displayName));
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            print('카테고리 로딩중... shimmer 나타내기');
          } else if (state is CategoryError) {
            print('카테고리 Error -> 다시 재 로드 버튼 할당하기');
          } else if (state is CategoryLoaded) {
            if (state.categoryPrograms.isEmpty) {
              return Center(child: Text("프로그램이 없습니다"));
            } else {
              return ListView.separated(
                itemCount: state.categoryPrograms.length,
                itemBuilder: (context, index) {
                  final program = state.categoryPrograms[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                    child: SizedBox(
                      height: 100,
                      child: CategoryTile(
                        program: program,
                        onTap: (program) {
                          Navigator.pushNamed(context, Routes.programDetail,
                              arguments: program.documentId);
                        },
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  if (index == state.categoryPrograms.length - 1) {
                    return const SizedBox.shrink();
                  }
                  return Divider(
                    thickness: 0.5,
                    color: Colors.grey[300],
                    indent: 13.0,
                    endIndent: 13.0,
                    height: 5.0,
                  );
                },
              );
            }
          }
          return Container();
        },
      ),
    );
  }
}
