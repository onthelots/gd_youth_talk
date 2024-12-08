import 'package:flutter/material.dart';
import 'package:gd_youth_talk/app/dummy_data.dart';

class CategoryScreen extends StatefulWidget {
  final int selectedIndex;

  // 더미데이터 기반, Parse 예시
  final List<Programs> programsList = programData.entries.map((entry) {
    return Programs.fromMap(entry.key, entry.value as Map<String, dynamic>);
  }).toList();

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
      length: widget.programsList.length,
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
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              unselectedLabelStyle: Theme.of(context).textTheme.bodyMedium,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Theme.of(context).primaryColor,
              indicatorWeight: 1.0,
              controller: _tabController,
              tabs: const [
                Tab(text: '건강&웰빙'),
                Tab(text: '자기계발'),
                Tab(text: '문화&취미'),
                Tab(text: '강연&포럼'),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: TabBarView(
          controller: _tabController,
          children: List.generate(widget.programsList.length, (index) {
            final programs = widget.programsList[index].items;
            return ListView.builder(
              itemCount: programs.length,
              itemBuilder: (context, itemIndex) {

                final program = programs[itemIndex];

                return ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  title: Text(program.title, style: Theme.of(context).textTheme.labelLarge),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(program.description, style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(height: 4.0),
                      // Text('일시: ${item.date.year}-${item.date.month}-${item.date.day} ${item.time.format(context)}', style: Theme.of(context).textTheme.bodySmall),
                      Text('위치: ${program.location}', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  trailing: Container(
                    child: Image.network(
                      program.thumbnailUrl,
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                    ),
                  ),
                  onTap: () {
                    // 항목을 클릭했을 때 처리할 로직
                    print('탭된 항목: ${program.title}');
                  },
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
