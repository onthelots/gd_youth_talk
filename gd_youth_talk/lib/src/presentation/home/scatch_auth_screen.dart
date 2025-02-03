import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/presentation/main/bloc/auth_status_bloc/auth_status_bloc.dart';
import 'package:gd_youth_talk/src/presentation/main/bloc/auth_status_bloc/auth_status_state.dart';

class ScatchAuthScreen extends StatelessWidget {
  const ScatchAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        //
      },
      builder: (context, state) {
        if (state is UserLoading) {
          return CircularProgressIndicator();
        } else if (state is UserLoggedIn) {
          return Scaffold(
            body: Center(
              child: Text(state.user.nickname ?? ''),
            ),
          );
        } else if (state is UserNotLoggedIn) {
          return Scaffold(
            body: Center(
              child: Text('not logged in'),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
