import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/core/constants.dart';
import 'package:gd_youth_talk/src/core/theme.dart';
import 'package:gd_youth_talk/src/presentation/bloc/program_bloc.dart';
import 'package:gd_youth_talk/src/core/di/setup_locator.dart';
import 'package:gd_youth_talk/src/domain/usecases/program_usecase.dart';
import 'package:gd_youth_talk/src/presentation/widgets/custom_listTile.dart';

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
      context.read<ProgramBloc>().add(GetProgramsByCategoryEvent(CategoryType.values[widget.selectedIndex].displayName));
    });
    return BlocBuilder<ProgramBloc, ProgramState>(
      builder: (context, state) {
        if (state is ProgramLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProgramsByCategoryLoadedState) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              centerTitle: true,
              title: const Text('카테고리'),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Container(
                  height: 50,
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
                      context.read<ProgramBloc>().add(
                        GetProgramsByCategoryEvent(
                          CategoryType.values[index].displayName,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            body: ListView.builder(
              itemCount: state.programsByCategory.length,
              itemBuilder: (context, index) {
                final program = state.programsByCategory[index];
                return ListTile(
                  title: Text(program.title ?? ""),
                  subtitle: Text(program.subtitle ?? ""),
                  onTap: () {
                    // 프로그램 상세내용 이동
                  },
                );
              },
            ),
          );
        } else if (state is ProgramErrorState) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('아무 데이터도 없습니다.'));
        }
      },
    );
  }
}

/*
   appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: const Text('카테고리'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            height: 50,
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
                context.read<ProgramBloc>().add(
                  GetProgramsByCategoryEvent(
                    CategoryType.values[index].displayName,
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<ProgramBloc, ProgramState>(
        builder: (context, state) {
          if (state is ProgramLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProgramsByCategoryLoadedState) {
            if (state.programsByCategory.isEmpty) {
              return const Center(
                child: Text('현재 카테고리에는 프로그램이 없습니다.'),
              );
            }
            return ListView.builder(
              itemCount: state.programsByCategory.length,
              itemBuilder: (context, index) {
                final program = state.programsByCategory[index];
                return ListTile(
                  title: Text(program.title ?? ""),
                  subtitle: Text(program.subtitle ?? ""),
                  onTap: () {
                    // Navigator.pushNamed(
                    //   context,
                    //   Routes.programDetail,
                    //   arguments: program,
                    // );
                  },
                );
              },
            );
          } else if (state is ProgramErrorState) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('아무 데이터도 없습니다.'));
          }
        },
      ),
 */



/*
             builder: (context, state) {
                    if (state is ProgramLoadingState) {
                      return CircularProgressIndicator();
                    } else if (state is ProgramsByCategoryLoadedState) {
                      if (state.programsByCategory.isEmpty) {
                        return Center(child: Text('현재 카테고리에는 프로그램이 없습니다.'));
                      }
                      return ListView.builder(
                        itemCount: state.programsByCategory.length,
                        itemBuilder: (context, index) {
                          final program = state.programsByCategory[index];
                          return ListTile(
                            title: Text(program.title ?? ""),
                            subtitle: Text(program.subtitle ?? ""),
                          );
                        },
                      );
                    } else if (state is ProgramErrorState) {
                      return Text('Error: ${state.message}');
                    } else {
                      return Text('무슨 상태인데..?');
                    }
                  }
 */




/*
        return TabBarView(
              controller: _tabController,
              children: List.generate(CategoryType.values.length, (index) {
                if (state is ProgramLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProgramsByCategoryLoadedState) {
                  return ListView.builder(
                    itemCount: state.programsByCategory.length,
                    itemBuilder: (context, itemIndex) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: SizedBox(
                          height: 150, // 항목 높이
                          child: CustomListTile(
                            program: state.programsByCategory[itemIndex],
                            onTap: (program) {
                              Navigator.pushNamed(context, Routes.programDetail,
                                  arguments: program);
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is ProgramErrorState) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return const Center(
                    child: Text(
                      '아무런 데이터가 없습니다.',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }
              }),
            );
 */
