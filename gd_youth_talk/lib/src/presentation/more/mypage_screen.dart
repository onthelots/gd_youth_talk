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
import 'package:gd_youth_talk/src/presentation/qr_code/qr_screen.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoggedIn) {
          print("로그인이 완료되었습니다.");
        } else if (state is UserNotLoggedIn) {
          print("로그인이 필요합니다.");
        }
      },
      builder: (context, state) {
        bool isUserLoggedIn = state is UserLoggedIn; // 로그인 여부
        String title = ''; // 로그인, 비 로그인 상태에서의 title
        String subtitle = ''; // 로그인, 비 로그인 상태에서의 subtitle
        Color containerColor = Theme.of(context).primaryColor; // 로그인, 비 로그인 상태의 container 색상

        if (state is UserLoggedIn) {
          title = "${state.user.nickname}님";
          subtitle = "오늘까지 총 ${state.user.visitCount}번 프로그램에 참여하셨어요";
          containerColor = Theme.of(context).primaryColor;
        } else if (state is UserNotLoggedIn) {
          title = "멤버십 로그인이 필요합니다";
          subtitle = "서울청년센터 강동의 다양한 정보와 혜택을 누려보세요";
          containerColor = Theme.of(context).disabledColor;
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
                          ? Navigator.pushNamed(context, Routes.user)
                          : _showLoginModal(context);
                    },
                    title: title,
                    subtitle: subtitle,
                    containerColor: containerColor,
                  ),

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

  // Modal Show Login
  static void _showLoginModal(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      isDismissible: true,
      // 모달 외부 터치 시 닫힘
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.3, // 화면 높이의 40% 차지
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 버튼 중앙 정렬
            children: [
              Text(
                "멤버십 회원으로 계속하기",
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),

              Text(
                "서울청년센터 강동 멤버십에 가입하고\n다양한 혜택을 누려보세요!",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // 캡슐 모양
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24), // 버튼 크기 조정

                  ),
                  onPressed: () {
                    Navigator.pop(context); // 모달 닫기
                    Navigator.pushNamed(context, Routes.regTerms); // 회원가입 뷰 이동
                  },
                  child: Text(
                    "회원가입",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('이미 가입하셨나요?', style: Theme.of(context).textTheme.bodyMedium),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // 모달 닫기
                      Navigator.pushNamed(context, Routes.signIn); // 회원가입 뷰 이동
                    },
                    child: Text('로그인', style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ],
              ),
            ],
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
    final userState = context.read<UserBloc>().state; // 현재 로그인 상태 가져오기
    if (userState is UserLoggedIn) {
      // 로그인 상태 → QR 코드 화면으로 이동
      QRCodeScreen.showQRCodeModal(context, userState.user.documentId!);
    } else {
      // 비로그인 상태 → 로그인 모달 띄우기
      MyPageScreen._showLoginModal(context);
    }
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
