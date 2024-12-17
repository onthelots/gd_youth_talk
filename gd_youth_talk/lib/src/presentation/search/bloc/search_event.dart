abstract class SearchProgramEvent {}

class SearchQueryProgramsEvent extends SearchProgramEvent {
  final String query;

  SearchQueryProgramsEvent({required this.query});
}
