abstract class SelectedProgramEvent {}

class GetProgramsByDate extends SelectedProgramEvent {
  final DateTime date;
  GetProgramsByDate(this.date);
}