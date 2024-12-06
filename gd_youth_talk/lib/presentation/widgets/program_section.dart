import 'package:flutter/material.dart';
import 'package:gd_youth_talk/app/dummy_data.dart';

/// Widgets 3. Section
//TODO : Bloc을 통해, 할당된 Program 데이터를 할당할 것
class Section extends StatelessWidget {
  final Category category;

  Section({
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Section text
          Text(
            category.name,
            style: Theme.of(context).textTheme.bodyLarge,
          ),

          // ListView
          SizedBox(
            height: 200, // 명확한 높이 지정
            child: ListView.builder(
              shrinkWrap: true, // 콘텐츠 크기에 따라 높이 결정
              scrollDirection: Axis.horizontal,
              itemCount: category.items.length, // item 갯수
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: ProgramSectionListTile(category: category, index: index,),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProgramSectionListTile extends StatelessWidget {
  final Category category;
  final int index;

  ProgramSectionListTile({
    required this.category,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      width: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                category.items[index].thumbnailUrl,
                width: 120, // 이미지 크기 조정
                height: 120,
                fit: BoxFit.cover, // 이미지 크기에 맞게 자르기
              ),
            ),

            SizedBox(
              height: 5,
            ),

            Text(
              category.items[index].title,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2, // max line
            )
          ],
        ),
      ),
    );
  }
}
