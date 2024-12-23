abstract class CategoryEvent {}

class LoadCategoryEvent extends CategoryEvent {
  final String category;
  LoadCategoryEvent(this.category);
}