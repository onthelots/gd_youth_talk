import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/core/constants.dart';
import 'package:gd_youth_talk/src/core/routes.dart';
import 'package:gd_youth_talk/src/core/theme.dart';
import 'package:gd_youth_talk/src/presentation/category/widgets/category_tile.dart';
import 'bloc/category_bloc.dart';
import 'bloc/category_event.dart';
import 'bloc/category_state.dart';

class CategoryScreen extends StatefulWidget {
  final int selectedIndex;

  CategoryScreen({required this.selectedIndex});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: CategoryType.values.length,
      vsync: this,
      initialIndex: widget.selectedIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryBloc>().add(GetProgramsByCategoryEvent(CategoryType.values[widget.selectedIndex].displayName));
    });

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoryLoadedState) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              centerTitle: true,
              title: const Text('카테고리'),
              scrolledUnderElevation: 0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Container(
                  width: double.infinity,
                  child: TabBar(
                    isScrollable: false,
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    unselectedLabelStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
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
                      // 탭 변경 시 이벤트 트리거
                      context.read<CategoryBloc>().add(
                        GetProgramsByCategoryEvent(
                          CategoryType.values[index].displayName,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            body: state.programs.isEmpty
            ? const Center(
              child: Text(
                '프로그램이 없습니다.'
              ),
            )
            :
            ListView.separated(
              itemCount: state.programs.length,
              itemBuilder: (context, index) {
                final program = state.programs[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                  child: SizedBox(
                    height: 100,
                    child: CategoryTile(
                      program: program,
                      onTap: (program) {
                        Navigator.of(context)
                            .pushNamed(Routes.programDetail, arguments: program);
                      },
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                if (index == state.programs.length - 1) {
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
            ),
          );
        } else if (state is CategoryErrorState) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('아무 데이터도 없습니다.'));
        }
      },
    );
  }
}