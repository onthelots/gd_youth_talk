import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/auth_title_column.dart';
import 'package:gd_youth_talk/src/presentation/auth/widgets/custom_buttom_navbar.dart';

class WelcomeAuthenticationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 0. 타이틀
            AuthTitleColumn(
              title: '가입을 환영합니다!',
              subtitle: '로그인 후 다양한 혜택과 각종 소식을 즐겨보세요',
            ),

            SizedBox(
              height: 100,
            ),

            Center(
              child: SizedBox(
                width: 150,
                height: 150,
                child: Lottie.asset('assets/animations/check_lottie.json', repeat: false),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: CustomButtomNavBar(
          title: '가입 완료',
          isLoading: false,
          onPressed: ()  {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        ),
      ),
    );
  }
}