import 'package:flutter/material.dart';
import 'package:gd_youth_talk/src/core/constants.dart';
import 'package:gd_youth_talk/src/core/routes.dart';
import 'package:gd_youth_talk/src/presentation/more/oss_license_screen.dart';
import 'package:gd_youth_talk/src/presentation/more/theme_screen.dart';
import 'widgets/menu_tile.dart';
import 'widgets/banner_container.dart';

final menuItems = [
  MenuItem(menuTitle: '인스타그램', route: WebRoutes.instagram),
  MenuItem(menuTitle: '공식 블로그', route: WebRoutes.blog),
  MenuItem(menuTitle: '카카오톡 문의하기', route: WebRoutes.customerService),
  MenuItem(menuTitle: '대관 신청', route: WebRoutes.coronation),
  MenuItem(menuTitle: '오시는 길', route: WebRoutes.location),
  MenuItem(menuTitle: '기본 테마 설정', route: Routes.setting, trailing: null),
  MenuItem(menuTitle: '이용 약관', route: WebRoutes.termsOfUse),
  MenuItem(menuTitle: '오픈소스 라이센스', route: Routes.openSource),
  MenuItem(menuTitle: '앱 버전', route: '', trailing: null),
];

class MoreScreen extends StatelessWidget {
  String _appVersion = 'v1.0'; // 앱 버전 상태

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
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 5),
        child: ListView.separated(
          itemCount: menuItems.length + 1, // 구분선은 2개 추가
          itemBuilder: (context, index) {

            /// 1. 배너 항목
            if (index == 0) {
              return BannerContainer(onTap: () {
                Navigator.pushNamed(context, Routes.webView, arguments: WebRoutes.introduce);
              });

              /// 2. 앱 버전
            } else if (index == menuItems.length) {
              final menuItem = menuItems.last;
              return MenuTile(
                menuTitle: menuItem.menuTitle,
                onTap: null, // onTap 없음
                trailing: Text(_appVersion), // 앱 버전 표시
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
              return const Divider(
                height: 10,
                thickness: 10,
              ); // 굵은 구분선
            }
            if (index == 3 || index == 6) {
              return const Divider(
                thickness: 10,
                height: 10,
              ); // 굵은 구분선
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

