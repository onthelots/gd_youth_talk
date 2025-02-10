import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/core/app_info/app_info_cubit.dart';
import 'package:gd_youth_talk/src/core/constants.dart';
import 'package:gd_youth_talk/src/core/routes.dart';
import 'package:gd_youth_talk/src/presentation/more/settings/setting/widgets/menu_section.dart';
import 'package:gd_youth_talk/src/presentation/more/settings/setting/widgets/menu_tile.dart';

class SettingMenuScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        title: Text(
          '설정',
          style: Theme
              .of(context)
              .textTheme
              .bodyLarge,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 5),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              BlocBuilder<AppInfoCubit, String>(
                builder: (context, version) {
                  return MenuSection(sectionTitle: '앱 설정', menuItem: [
                    MenuTile(
                      menuTitle: '앱 버전',
                      onTap: null,
                      trailing: Text('v${version}'),
                    ),
                    MenuTile(
                      menuTitle: '기본 테마 설정',
                      onTap: (context) {
                        Navigator.pushNamed(context, Routes.themeSetting);
                      },
                    )
                  ]);
                },
              ),
              MenuSection(sectionTitle: '약관 및 라이센스', menuItem: [
                MenuTile(
                  menuTitle: '이용약관',
                  onTap: (context) {
                    Navigator.pushNamed(context, Routes.webView, arguments: WebRoutes.termsOfUse);
                  },
                ),
                MenuTile(
                  menuTitle: '개인정보 처리방침',
                  onTap: (context) {
                    Navigator.pushNamed(context, Routes.webView, arguments: WebRoutes.privacyPolicy);
                  },
                ),
                MenuTile(
                  menuTitle: '오픈소스 라이센스',
                  onTap: (context) {
                    Navigator.pushNamed(context, Routes.openSource);
                  },
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
