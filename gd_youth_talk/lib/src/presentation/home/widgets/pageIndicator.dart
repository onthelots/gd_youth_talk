import 'package:flutter/material.dart';
import 'package:gd_youth_talk/src/core/constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageIndicator extends StatelessWidget {
  final PageController pageController;
  final int pageCount;

  PageIndicator({required this.pageCount, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: SmoothPageIndicator(
          controller: pageController,
          count: pageCount,
          effect: ScrollingDotsEffect(
            activeDotColor: Theme.of(context).brightness == Brightness.light
                ? AppColors.lightPrimary
                : AppColors.darkPrimary,
            radius: 8,
            spacing: 10,
            dotHeight: 8,
            dotWidth: 8,
          )),
    );
  }
}