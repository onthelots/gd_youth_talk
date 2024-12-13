import 'package:flutter/material.dart';
import 'package:gd_youth_talk/core/theme.dart';
import 'package:gd_youth_talk/app/routes.dart';
import 'package:gd_youth_talk/data/models/program_model.dart';
import 'package:gd_youth_talk/presentation/widgets/custom_listTile.dart';

class CategoryScreen extends StatefulWidget {
  final int selectedIndex;

  CategoryScreen({Key? key, required this.selectedIndex})
      : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
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
        title: const Text('카테고리'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            height: 50,
            width: double.infinity,
            child: TabBar(
              isScrollable: false,
              labelStyle: Theme.of(context).textTheme.labelMedium,
              unselectedLabelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.unselectedLabelColor(context),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Theme.of(context).primaryColor,
              indicatorWeight: 1.0,
              controller: _tabController,
              tabs: [
                // for (final category in CategoryType.values)
                //   Tab(text: category.displayName)
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: TabBarView(
          controller: _tabController,
          children: List.generate(4, (index) {
            // final programs = widget.programsList[index].items;
            return ListView.builder(
              itemCount: 4,
              itemBuilder: (context, itemIndex) {

                // final program = programs[itemIndex];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0), // 항목 간격 추가
                  child: SizedBox(
                    height: 150, // 150
                    child: CustomListTile(
                      program: ProgramModel(),
                      onTap: (program) {
                        Navigator.pushNamed(context, Routes.programDetail, arguments: program);
                      },
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}