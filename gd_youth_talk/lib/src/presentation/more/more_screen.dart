import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/core/app_info/app_info_cubit.dart';
import 'package:gd_youth_talk/src/core/constants.dart';
import 'package:gd_youth_talk/src/core/routes.dart';
import 'package:gd_youth_talk/src/presentation/auth/screens/terms/reg_terms_screen.dart';
import 'package:gd_youth_talk/src/presentation/more/oss_license_screen.dart';
import 'package:gd_youth_talk/src/presentation/more/theme_screen.dart';
import 'widgets/menu_tile.dart';
import 'widgets/banner_container.dart';

final menuItems = [
  MenuItem(menuTitle: '인스타그램', route: WebRoutes.instagram),
  MenuItem(menuTitle: '공식 블로그', route: WebRoutes.blog),
  MenuItem(menuTitle: '인스타그램', route: WebRoutes.customerService),
  MenuItem(menuTitle: '출석체크', route: WebRoutes.coronation),
  MenuItem(menuTitle: '공지사항', route: Routes.setting),
  MenuItem(menuTitle: '대관신청', route: WebRoutes.termsOfUse),
  MenuItem(menuTitle: '스크랩', route: Routes.openSource),
  MenuItem(menuTitle: '홈페이지', route: WebRoutes.introduce),
];

class MoreScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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
                '더보기',
                style: Theme.of(context).textTheme.displayMedium
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.regTerms);
            },
            icon: Icon(Icons.add_circle),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 5),
        child: ListView.separated(
          itemCount: menuItems.length + 1, // 상단 배너 +1
          itemBuilder: (context, index) {

            /// 1. 배너 항목
            if (index == 0) {
              return SizedBox.shrink();
              // return BannerContainer(onTap: () {
              //   Navigator.pushNamed(context, Routes.webView, arguments: WebRoutes.introduce);
              // });

              /// 2. 앱 버전
            } else if (index == menuItems.length) {
              final menuItem = menuItems.last;

              // App Version (cubit)
              return BlocBuilder<AppInfoCubit, String>(
                builder: (context, version) {
                  return MenuTile(
                    menuTitle: menuItem.menuTitle,
                    onTap: null, // onTap 없음
                    trailing: Text(
                      'v${version}',
                    ),
                  );
                },
              );

              /// 3. '기본 테마 설정' 메뉴 항목
            } else if (menuItems[index - 1].menuTitle == '기본 테마 설정') {
              return MenuTile(
                menuTitle: menuItems[index - 1].menuTitle,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ThemeSettingsScreen()), // ThemeSettingsScreen으로 이동
                  );
                },
              );
            } else if (menuItems[index - 1].menuTitle == '오픈소스 라이센스') {
              return MenuTile(
                menuTitle: menuItems[index - 1].menuTitle,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OssLicensesPage()), // OssLicensesPage로 이동
                  );
                },
              );
            } else {
              final menuItem = menuItems[index - 1];
              return MenuTile(
                menuTitle: menuItem.menuTitle,
                onTap: menuItem.route.isNotEmpty
                    ? () => Navigator.pushNamed(context, Routes.webView, arguments: menuItem.route)
                    : null,
              );
            }
          },
          separatorBuilder: (context, index) {
            if (index == 0) {
              return const SizedBox(
                height: 10,
              );
            }
            return const Divider(thickness: 0.5,
              indent: 13,
              endIndent: 13,
            ); // 얇은 구분선
          },
        ),
      ),
    );
  }
}

