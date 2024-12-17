abstract class CategoryEvent {}

class GetProgramsByCategoryEvent extends CategoryEvent {
  final String category;
  GetProgramsByCategoryEvent(this.category);
}
