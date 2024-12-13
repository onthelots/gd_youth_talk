import 'package:flutter_bloc/flutter_bloc.dart';

// 이벤트 정의
abstract class BottomNavEvent {}

class TabSelected extends BottomNavEvent {
  final int index;
  TabSelected(this.index);
}

// 상태 정의
abstract class BottomNavState {}

class TabState extends BottomNavState {
  final int index;
  TabState(this.index);
}

// Bloc 정의
class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(TabState(0)) {
    on<TabSelected>((event, emit) {
      emit(TabState(event.index));
    });
  }
}
