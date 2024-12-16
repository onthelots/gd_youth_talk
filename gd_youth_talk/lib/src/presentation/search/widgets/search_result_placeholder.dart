import 'package:flutter/material.dart';

class SearchResultPlaceholder extends StatelessWidget {
  const SearchResultPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.dynamic_feed,
            size: 50,
            color: Theme.of(context).focusColor,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            '강동 청년센터의 프로그램이 궁금하시다면?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            '키워드(문화, 취미, 강연 등)로 검색해보세요!',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
