import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                          _showEditNicknameDialog(context, state.user.nickname);
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

// 닉네임 수정 다이얼로그
  void _showEditNicknameDialog(BuildContext context, String? currentNickname) {
    final TextEditingController nicknameController = TextEditingController(text: currentNickname);
    final bloc = context.read<UserBloc>(); // Bloc을 읽어옴

    showDialog(
      context: context,
      builder: (dialogContext) {
        // iOS와 Android에 맞는 다이얼로그 스타일을 구분
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Padding(
              padding: EdgeInsets.only(bottom: 15.0), // title과 content 사이 간격
              child: Text(
                "이름(닉네임) 수정",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            content: Padding(
              padding: EdgeInsets.only(bottom: 12.0), // content와 actions 사이 간격
              child: CupertinoTextField(
                controller: nicknameController,
                placeholder: '최대 한글 6자, 영문 12자 입력',
                inputFormatters: [
                  LengthLimitingTextInputFormatter(12), // 최대 12자 제한
                  _NicknameInputFormatter(), // 한글 6자 제한
                ],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(dialogContext); // 닫기
                },
                child: Text("취소", style: Theme.of(context).textTheme.labelMedium,),
              ),

              CupertinoDialogAction(
                onPressed: () {
                  final newNickname = nicknameController.text.trim();
                  if (newNickname.isNotEmpty) {
                    bloc.add(UpdateNicknameRequested(newNickname: newNickname));
                    Navigator.pop(dialogContext); // 닫기
                  }
                },
                child: Text("확인", style: Theme.of(context).textTheme.labelMedium,),
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: Text(
              "이름(닉네임) 수정",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            content: TextField(
              controller: nicknameController,
              decoration: InputDecoration(
                  hintText: '최대 한글 6자, 영문 12자 입력',
                  labelStyle: Theme.of(context).textTheme.bodyMedium),
              inputFormatters: [
                LengthLimitingTextInputFormatter(12), // 최대 12자 제한
                _NicknameInputFormatter(), // 한글 6자 제한
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext); // 닫기
                },
                child: Text("취소", style: Theme.of(context).textTheme.labelMedium,),
              ),
              TextButton(
                onPressed: () {
                  final newNickname = nicknameController.text.trim();
                  if (newNickname.isNotEmpty) {
                    bloc.add(UpdateNicknameRequested(newNickname: newNickname));
                    Navigator.pop(dialogContext); // 닫기
                  }
                },
                child: Text("확인", style: Theme.of(context).textTheme.labelMedium,),
              ),
            ],
          );
        }
      },
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
            mainAxisAlignment: MainAxisAlignment.start, // 버튼 중앙 정렬
            children: [
              Icon(
                Icons.warning,
                size: 50,
              ),
              const SizedBox(height: 10),

              Text(
                "회원탈퇴를 진행하시겠습니까?",
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

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

// 한글 6자, 영문 12자 제한을 위한 TextInputFormatter
class _NicknameInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    // 한글 문자 수 계산
    int koreanCount = newText.runes.where((rune) => rune > 128).length;

    // 한글은 6자, 영문은 12자 제한
    if (koreanCount > 6) {
      newText = newText.substring(0, 6);
    } else if (newText.length > 12) {
      newText = newText.substring(0, 12);
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
