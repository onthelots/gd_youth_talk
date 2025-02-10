import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_youth_talk/src/presentation/main/bloc/bottom_nav_bloc/bottom_nav_event.dart';
import 'package:gd_youth_talk/src/presentation/main/bloc/bottom_nav_bloc/bottom_nav_state.dart';

class BottomNavBloc extends Bloc<TabSelected, TabState> {
  BottomNavBloc() : super(TabState(0)) {
    on<TabSelected>((event, emit) {
      emit(TabState(event.index));
    });
  }
}
