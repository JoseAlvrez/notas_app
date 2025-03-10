import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notas_app/models/note.dart';
import 'package:notas_app/repositories/note_repository.dart';

class NoteBloc extends Cubit<List<Note>> {
  final NoteRepository noteRepository;
  final String userId;

  NoteBloc(this.noteRepository, this.userId) : super([]);

  void loadNotes() {
    noteRepository.getNotes(userId).listen((notes) => emit(notes));
  }

  void addNote(Note note) async {
    await noteRepository.addNote(userId, note);
  }

  void updateNote(Note note) async {
    await noteRepository.updateNote(userId, note);
  }

  void deleteNote(String noteId) async {
    await noteRepository.deleteNote(userId, noteId);
  }
}
