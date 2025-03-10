import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notas_app/blocs/note_bloc.dart';
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
      noteBloc = NoteBloc(noteRepository, userId);
    });

    test(
      'loadNotes emite la lista de notas cuando se añaden documentos',
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
        noteBloc.loadNotes();
        await Future.delayed(const Duration(milliseconds: 100));

        final currentState = noteBloc.state;
        expect(currentState.length, 1);
        expect(currentState[0].title, 'Nota1');
        expect(currentState[0].content, 'Contenido1');
        expect(currentState[0].category, 'Cat1');
      },
    );

    test('addNote añade una nota y el bloc emite la nueva lista', () async {
      // Al llamar addNote, se crea el doc en Firestore
      final note = Note(
        id: '',
        title: 'Nota2',
        content: 'Contenido2',
        category: 'Cat2',
        createdAt: DateTime.now(),
      );

      //Primero llamamos loadNotes para que el bloc escuche los cambios
      noteBloc.loadNotes();

      noteBloc.addNote(note);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(noteBloc.state.length, 1);
      expect(noteBloc.state[0].title, 'Nota2');
    });

    test('updateNote actualiza una nota y emite la nueva lista', () async {
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
      noteBloc.loadNotes();
      await Future.delayed(const Duration(milliseconds: 50));

      //Actualizamos
      final updatedNote = Note(
        id: existingId,
        title: 'Nota3 actualizada',
        content: 'Contenido3 modificado',
        category: 'Cat3 new',
        createdAt: DateTime.now(),
      );
      noteBloc.updateNote(updatedNote);
      await Future.delayed(const Duration(milliseconds: 100));

      //Verificamos en el estado
      final currentState = noteBloc.state;
      expect(currentState.length, 1);
      expect(currentState[0].title, 'Nota3 actualizada');
      expect(currentState[0].content, 'Contenido3 modificado');
      expect(currentState[0].category, 'Cat3 new');
    });

    test('deleteNote elimina una nota y emite la nueva lista', () async {
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
      noteBloc.loadNotes();
      await Future.delayed(const Duration(milliseconds: 50));

      //Eliminamos la nota
      noteBloc.deleteNote(existingId);
      await Future.delayed(const Duration(milliseconds: 100));

      //Verificamos que ya no haya notas
      final currentState = noteBloc.state;
      expect(currentState.length, 0);
    });
  });
}
