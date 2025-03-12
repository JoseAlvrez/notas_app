import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notas_app/blocs/note_bloc/note_bloc.dart';
import 'package:notas_app/blocs/note_bloc/note_event.dart';
import 'package:notas_app/models/note.dart';
import 'package:notas_app/repositories/note_repository.dart';

void main() {
  group('Notebloc tests', () {
    late FakeFirebaseFirestore fakeFirestore;
    late NoteRepository noteRepository;
    late NoteBloc noteBloc;

    const userId = 'fakeUserId';

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      noteRepository = NoteRepository(fakeFirestore);
      noteBloc = NoteBloc(noteRepository: noteRepository, userId: userId);
    });

    test(
      'loadNotes, emite la lista de notas cuando se añaden documentos',
      () async {
        //Creamos manualmente un doc en Firestore
        await fakeFirestore
            .collection('users')
            .doc(userId)
            .collection('notes')
            .add({
              'title': 'Nota1',
              'content': 'Contenido1',
              'category': 'Cat1',
              'createdAt': DateTime.now(),
            });

        //Llammos a loadNotes
        noteBloc.add(LoadNotes(userId));
        await Future.delayed(const Duration(milliseconds: 100));

        // Verificamos el estado actual del bloc
        final currentState = noteBloc.state;
        // Como noteBloc.state es un NoteState, accedemos a la lista con currentState.allNotes
        expect(currentState.allNotes.length, 1);
        expect(currentState.allNotes[0].title, 'Nota1');
        expect(currentState.allNotes[0].content, 'Contenido1');
        expect(currentState.allNotes[0].category, 'Cat1');
      },
    );

    test('addNote, añade una nota y el bloc emite la nueva lista', () async {
      // Creamos la nota, se crea el doc en Firestore
      final note = Note(
        id: '',
        title: 'Nota2',
        content: 'Contenido2',
        category: 'Cat2',
        createdAt: DateTime.now(),
      );

      // Iniciamos la escucha de notas
      noteBloc.add(LoadNotes(userId));

      // Disparamos el evento de agregar nota
      noteBloc.add(AddNote(note));
      await Future.delayed(const Duration(milliseconds: 100));

      final currentState = noteBloc.state;
      expect(currentState.allNotes.length, 1);
      expect(currentState.allNotes[0].title, 'Nota2');
    });

    test('updateNote, actualiza una nota y emite la nueva lista', () async {
      //Creamos un doc manualmente
      final docRef = await fakeFirestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .add({
            'title': 'Nota3',
            'content': 'Contenido3',
            'category': 'Cat3',
            'createdAt': DateTime.now(),
          });
      final existingId = docRef.id;

      //Empezamos a escuchar noteBloc
      noteBloc.add(LoadNotes(userId));
      await Future.delayed(const Duration(milliseconds: 50));

      //Actualizamos la nota
      final updatedNote = Note(
        id: existingId,
        title: 'Nota3 actualizada',
        content: 'Contenido3 modificado',
        category: 'Cat3 new',
        createdAt: DateTime.now(),
      );

      noteBloc.add(UpdateNote(updatedNote));
      await Future.delayed(const Duration(milliseconds: 100));

      //Verificamos en el estado
      final currentState = noteBloc.state;
      expect(currentState.allNotes.length, 1);
      expect(currentState.allNotes[0].title, 'Nota3 actualizada');
      expect(currentState.allNotes[0].content, 'Contenido3 modificado');
      expect(currentState.allNotes[0].category, 'Cat3 new');
    });

    test('deleteNote, elimina una nota y emite la nueva lista', () async {
      //Creamos un doc
      final docRef = await fakeFirestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .add({
            'title': 'Nota4',
            'content': 'Contenido4',
            'category': 'Cat4',
            'createdAt': DateTime.now(),
          });
      final existingId = docRef.id;

      //Empezamos a escuchar noteBloc
      noteBloc.add(LoadNotes(userId));
      await Future.delayed(const Duration(milliseconds: 50));

      //Disparamos el evento para eliminar la nota
      noteBloc.add(DeleteNote(existingId));
      await Future.delayed(const Duration(milliseconds: 100));

      //Verificamos que ya no haya notas
      final currentState = noteBloc.state;
      expect(currentState.allNotes.length, 0);
    });
  });
}
