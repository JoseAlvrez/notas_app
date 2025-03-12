import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notas_app/blocs/note_bloc/note_event.dart';
import 'package:notas_app/blocs/note_bloc/note_state.dart';
import 'package:notas_app/repositories/note_repository.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository noteRepository;
  final String userId;

  NoteBloc({required this.noteRepository, required this.userId})
    : super(const NoteState()) {
    // Registramos los handlers para cada evento:
    on<LoadNotes>(_onLoadNotes);
    on<NotesUpdated>(_onNotesUpdated);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<TitleChanged>(_onTitleChanged);
    on<ContentChanged>(_onContentChanged);
    on<CategoryChanged>(_onCategoryChanged);
    on<ResetForm>(_onResetForm);

    // Disparamos el evento inicial para cargar las notas
    add(LoadNotes(userId));
  }

  void _onLoadNotes(LoadNotes event, Emitter<NoteState> emit) {
    // Escuchamos el stream de notas del repositorio
    noteRepository.getNotes(event.userId).listen((notes) {
      // Cada vez que lleguen notas nuevas, disparamos un evento "NotesUpdated"
      add(NotesUpdated(notes));
    });
  }

  void _onNotesUpdated(NotesUpdated event, Emitter<NoteState> emit) {
    // Reemplazamos la lista de notas en el estado
    emit(state.copyWith(allNotes: event.notes));
  }

  Future<void> _onAddNote(AddNote event, Emitter<NoteState> emit) async {
    await noteRepository.addNote(userId, event.note);
  }

  Future<void> _onUpdateNote(UpdateNote event, Emitter<NoteState> emit) async {
    await noteRepository.updateNote(userId, event.note);
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NoteState> emit) async {
    await noteRepository.deleteNote(userId, event.noteId);
  }

  // Método para actualizar el searchQuery
  void _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<NoteState> emit,
  ) {
    // Actualizamos el searchQuery en el estado
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onTitleChanged(TitleChanged event, Emitter<NoteState> emit) {
    final String title = event.title.trim();
    String? errorMsg;
    if (title.isEmpty) {
      errorMsg = "El título es obligatorio";
    }
    final newTitle = event.title;
    // Se recalcula isFormValid en base a los tres campos
    final valid =
        newTitle.isNotEmpty &&
        state.editingContent.trim().isNotEmpty &&
        state.editingCategory.trim().isNotEmpty;
    emit(
      state.copyWith(
        editingTitle: newTitle,
        titleError: errorMsg,
        isFormValid: valid,
      ),
    );
  }

  void _onContentChanged(ContentChanged event, Emitter<NoteState> emit) {
    final content = event.content.trim();
    String? errorMsg;
    if (content.isEmpty) {
      errorMsg = "El contenido es obligatorio";
    }

    final valid =
        state.editingTitle.trim().isNotEmpty &&
        content.isNotEmpty &&
        state.editingCategory.trim().isNotEmpty;
    emit(
      state.copyWith(
        editingContent: event.content,
        contentError: errorMsg,
        isFormValid: valid,
      ),
    );
  }

  void _onCategoryChanged(CategoryChanged event, Emitter<NoteState> emit) {
    final category = event.category.trim();
    String? errorMsg;
    if (category.isEmpty) {
      errorMsg = "La categoría es obligatoria";
    }
    final valid =
        state.editingTitle.trim().isNotEmpty &&
        state.editingContent.trim().isNotEmpty &&
        category.isNotEmpty;
    emit(
      state.copyWith(
        editingCategory: event.category,
        categoryError: errorMsg,
        isFormValid: valid,
      ),
    );
  }

  void _onResetForm(ResetForm event, Emitter<NoteState> emit) {
    emit(
      state.copyWith(
        editingTitle: '',
        editingContent: '',
        editingCategory: '',
        titleError: null,
        contentError: null,
        categoryError: null,
        isFormValid: false,
      ),
    );
  }
}
