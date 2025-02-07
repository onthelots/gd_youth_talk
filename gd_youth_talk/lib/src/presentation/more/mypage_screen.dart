import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:gd_youth_talk/src/core/constants.dart';
import 'package:gd_youth_talk/src/core/routes.dart';
import 'package:gd_youth_talk/src/presentation/home/widgets/program_section.dart';
import 'package:gd_youth_talk/src/presentation/main/bloc/auth_status_bloc/auth_status_bloc.dart';
import 'package:gd_youth_talk/src/presentation/main/bloc/auth_status_bloc/auth_status_state.dart';
import 'package:gd_youth_talk/src/presentation/more/widgets/banner_container.dart';
import 'package:gd_youth_talk/src/presentation/more/widgets/icon_title_grid.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoggedIn) {
        } else if (state is UserNotLoggedIn) {}
      },
      builder: (context, state) {
        bool isUserLoggedIn = state is UserLoggedIn;
        String title = '';
        String subtitle = '';

        if (state is UserLoggedIn) {
          title = "${state.user.nickname}님";
          subtitle = "오늘까지 총 ${state.user.visitCount}번 프로그램에 참여하셨어요";
        } else if (state is UserNotLoggedIn) {
          title = "멤버십 로그인이 필요합니다";
          subtitle = "강동센터의 다양한 장보, 혜택을 누려보세요";
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            scrolledUnderElevation: 0,
            leadingWidth: 200.0,
            leading: Align(
              alignment: Alignment.centerLeft, // 세로축 중앙, 가로축 왼쪽 정렬
              child: Padding(
                padding: const EdgeInsets.only(left: 13.0), // 좌측 여백 조정
                child: Text('마이페이지',
                    style: Theme.of(context).textTheme.labelLarge),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  //
                },
                icon: Icon(Icons.qr_code_outlined),
              ),

              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, Routes.setting);
                },
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 13.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  UserBanner(
                      onTap: () {
                        isUserLoggedIn
                            ? print('유저 정보 관리 창으로 이동')
                            : print('회원가입&로그인 창으로 이동');
                      },
                      title: title,
                      subtitle: subtitle,
                      icon: Icons.login),


                  const SizedBox(
                    height: 20,
                  ),

                  IconTitleGrid(items: items),

                  const SizedBox(
                    height: 20,
                  ),
                  Section(sectionTitle: '최근 본 프로그램', programs: []),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// icon navigator
final List<IconTitleItem> items = [
  IconTitleItem(icon: FeatherIcons.messageCircle, title: "1:1 문의하기", onTap: (context) {
    Navigator.pushNamed(context, Routes.webView, arguments: WebRoutes.customerService);
  }),
  IconTitleItem(icon: FeatherIcons.globe, title: "공식 블로그", onTap: (context) {
    Navigator.pushNamed(context, Routes.webView, arguments: WebRoutes.blog);
  }),
  IconTitleItem(icon: FeatherIcons.instagram, title: "인스타그램", onTap: (context) {
    Navigator.pushNamed(context, Routes.webView, arguments: WebRoutes.instagram);
  }),
  IconTitleItem(icon: FeatherIcons.checkSquare, title: "출석체크", onTap: (context) {
    print("출석 체크 QR 보러가기");
  }),
  IconTitleItem(icon: FeatherIcons.bell, title: "공지사항", onTap: (context) {
    print("공지사항 리스트 보러가기");
  }),
  IconTitleItem(icon: FeatherIcons.calendar, title: "대관신청", onTap: (context) {
    Navigator.pushNamed(context, Routes.webView, arguments: WebRoutes.coronation);
  }),
  IconTitleItem(icon: FeatherIcons.star, title: "스크랩", onTap: (context) {
    print("내가 좋아요를 누른 스크랩 리스트 보러가기");
  }),
  IconTitleItem(icon: FeatherIcons.info, title: "홈페이지", onTap: (context) {
    Navigator.pushNamed(context, Routes.webView, arguments: WebRoutes.homepage);
  }),
];
