import 'package:equatable/equatable.dart';
import 'package:notas_app/models/note.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object?> get props => [];
}

// Evento para iniciar la carga de notas
class LoadNotes extends NoteEvent {
  final String userId;
  const LoadNotes(this.userId);

  @override
  List<Object?> get props => [userId];
}

// Evento que se dispara cuando llegan nuevas notas desde el repositorio
class NotesUpdated extends NoteEvent {
  final List<Note> notes;
  const NotesUpdated(this.notes);

  @override
  List<Object?> get props => [notes];
}

// Evento para añadir una nueva nota
class AddNote extends NoteEvent {
  final Note note;
  const AddNote(this.note);

  @override
  List<Object?> get props => [note];
}

// Evento para actualizar una nota existente
class UpdateNote extends NoteEvent {
  final Note note;
  const UpdateNote(this.note);

  @override
  List<Object?> get props => [note];
}

// Evento para eliminar una nota por su ID
class DeleteNote extends NoteEvent {
  final String noteId;
  const DeleteNote(this.noteId);

  @override
  List<Object?> get props => [noteId];
}

// Evento para cambiar el query de búsqueda (filtrado de notas)
class SearchQueryChanged extends NoteEvent {
  final String query;
  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class TitleChanged extends NoteEvent {
  final String title;
  const TitleChanged(this.title);

  @override
  List<Object?> get props => [title];
}

class ContentChanged extends NoteEvent {
  final String content;
  const ContentChanged(this.content);

  @override
  List<Object?> get props => [content];
}

class CategoryChanged extends NoteEvent {
  final String category;
  const CategoryChanged(this.category);

  @override
  List<Object?> get props => [category];
}

class ResetForm extends NoteEvent {
  const ResetForm();

  @override
  List<Object?> get props => [];
}
