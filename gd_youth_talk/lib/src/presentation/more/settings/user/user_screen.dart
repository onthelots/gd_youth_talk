import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/custom_exit_dialog.dart';
import 'package:gd_youth_talk/src/presentation/main/bloc/auth_status_bloc/auth_status_bloc.dart';
import 'package:gd_youth_talk/src/presentation/main/bloc/auth_status_bloc/auth_status_event.dart';
import 'package:gd_youth_talk/src/presentation/main/bloc/auth_status_bloc/auth_status_state.dart';
import 'package:gd_youth_talk/src/presentation/more/settings/setting/widgets/menu_section.dart';
import 'package:gd_youth_talk/src/presentation/more/settings/setting/widgets/menu_tile.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        title: Text(
          '내 정보 관리',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 5),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: BlocConsumer<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserNotLoggedIn) {
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              if (state is UserLoggedIn) {
                return Column(
                  children: [
                    MenuSection(sectionTitle: '회원정보', menuItem: [
                      MenuTile(
                        menuTitle: '이메일',
                        onTap: null,
                        trailing: Text(
                          '${state.user.email}',
                          style:
                              TextStyle(color: Theme.of(context).disabledColor),
                        ),
                      ),
                      MenuTile(
                        menuTitle: '이름(닉네임)',
                        onTap: (context) {
                          // 닉네임 수정
                        },
                        trailing: Text('${state.user.nickname}'),
                      ),
                      MenuTile(
                        menuTitle: '방문(참가)횟수',
                        onTap: null,
                        trailing: Text('${state.user.visitCount}회'),
                      ),
                    ]),
                    MenuSection(sectionTitle: '관리', menuItem: [
                      MenuTile(
                        menuTitle: '로그아웃',
                        onTap: (context) {
                          _showLogoutDialog(context);
                        },
                      ),
                      MenuTile(
                        menuTitle: '회원탈퇴',
                        onTap: (context) {
                          _showDeleteUserDialog(context);
                        },
                      ),
                    ]),
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final bloc = context.read<UserBloc>(); // Bloc을 먼저 읽음
    showDialog(
      context: context,
      builder: (dialogContext) => CustomExitDialog(
        title: "로그아웃",
        content: "현재 계정을 로그아웃 하시겠습니까?",
        cancelButtonText: "로그아웃",
        continueButtonText: "취소",
        onCancel: () {
          bloc.add(LogoutRequested());
          Navigator.pop(dialogContext);
        },
        onContinue: () {
          Navigator.pop(dialogContext);
        },
      ),
    );
  }

  // Modal Show Login
  void _showDeleteUserDialog(BuildContext context) {
    final bloc = context.read<UserBloc>(); // Bloc을 먼저 읽음
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
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 버튼 중앙 정렬
            children: [
              Icon(
                Icons.warning,
                size: 50,
              ),
              const SizedBox(height: 5),

              Text(
                "멤버십 및 회원탈퇴를 진행하시겠습니까?",
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 5),

              Text(
                "멤버십 혜택을 비롯한\n방문횟수 등의 정보는 모두 삭제됩니다",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // 캡슐 모양
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24), // 버튼 크기 조정

                  ),
                  onPressed: () {
                    bloc.add(DeleteUserRequested());
                    Navigator.pop(context); // 모달 닫기
                    // 회원탈퇴 실시
                  },
                  child: Text(
                    "회원탈퇴 및 멤버십 종료",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
