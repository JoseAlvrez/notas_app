import 'package:equatable/equatable.dart';
import 'package:notas_app/models/note.dart';

class NoteState extends Equatable {
  final List<Note> allNotes;
  final String searchQuery;

  final String editingTitle;
  final String editingContent;
  final String editingCategory;
  final String? titleError;
  final String? contentError;
  final String? categoryError;
  final bool isFormValid;

  const NoteState({
    this.allNotes = const [],
    this.searchQuery = '',
    this.editingTitle = '',
    this.editingContent = '',
    this.editingCategory = '',
    this.titleError,
    this.contentError,
    this.categoryError,
    this.isFormValid = false,
  });

  // Calcula la lista filtrada basándose en searchQuery
  List<Note> get filteredNotes {
    final query = searchQuery.toLowerCase();
    return allNotes.where((note) {
      final title = note.title.toLowerCase();
      final category = note.category.toLowerCase();
      final content = note.content.toLowerCase();
      return title.contains(query) ||
          category.contains(query) ||
          content.contains(query);
    }).toList();
  }

  NoteState copyWith({
    List<Note>? allNotes,
    String? searchQuery,
    String? editingTitle,
    String? editingContent,
    String? editingCategory,
    String? titleError,
    String? contentError,
    String? categoryError,
    bool? isFormValid,
  }) {
    return NoteState(
      allNotes: allNotes ?? this.allNotes,
      searchQuery: searchQuery ?? this.searchQuery,
      editingTitle: editingTitle ?? this.editingTitle,
      editingContent: editingContent ?? this.editingContent,
      editingCategory: editingCategory ?? this.editingCategory,
      titleError: titleError,
      contentError: contentError,
      categoryError: categoryError,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  @override
  List<Object?> get props => [
    allNotes,
    searchQuery,
    editingTitle,
    editingContent,
    editingCategory,
    titleError,
    contentError,
    categoryError,
    isFormValid,
  ];
}
