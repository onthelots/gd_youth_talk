abstract class ProgramDetailEvent {}

class LoadProgramDetailEvent extends ProgramDetailEvent {
  final String docId;
  LoadProgramDetailEvent(this.docId);
}