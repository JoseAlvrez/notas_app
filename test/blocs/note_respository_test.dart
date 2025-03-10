import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notas_app/models/note.dart';
import 'package:notas_app/repositories/note_repository.dart';

void main() {
  /*test("Prueba simple con fake_cloud_firestore", () async {
    final fakeFirestore = FakeFirebaseFirestore();
    final noteRepository = NoteRepository(fakeFirestore);
  });*/

  group('NoteRepository test', () {
    late NoteRepository noteRepository;
    late FakeFirebaseFirestore fakeFirestore;

    const userId = 'fakeUserId';

    setUp(() {
      // 1. Creamos la instancia en memoria
      fakeFirestore = FakeFirebaseFirestore();
      // 2. Inyectamos en el repositorio
      noteRepository = NoteRepository(fakeFirestore);
    });

    test("getNotes regresa un Stream de notas", () async {
      await fakeFirestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .add({
            'id': '',
            'title': 'Nota1',
            'content': 'Contenido1',
            'category': 'Categoria1',
            'createdAt': DateTime.now(),
          });
      // 4. Llamamos al método getNotes
      final notesStream = noteRepository.getNotes(userId);
      // Obtenemos la primera emisión del Stream
      final notesList = await notesStream.first;

      expect(notesList.length, 1);
      expect(notesList[0].title, 'Nota1');
      expect(notesList[0].category, 'Categoria1');
    });

    test("addNote crea un documento en Firestore", () async {
      final note = Note(
        id: '',
        title: 'Nueva Nota',
        content: 'Contenido de la nota',
        category: 'Personal',
        createdAt: DateTime.now(),
      );

      await noteRepository.addNote(userId, note);

      // Revisamos si se creó un doc
      final snapshot =
          await fakeFirestore
              .collection('users')
              .doc(userId)
              .collection('notes')
              .get();

      expect(snapshot.docs.length, 1);
      expect(snapshot.docs[0]['title'], 'Nueva Nota');
      expect(snapshot.docs[0]['category'], 'Personal');
    });

    test('updateNote actualiza un documento existente', () async {
      // 1. Creamos un doc manualmente
      final docRef = await fakeFirestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .add({
            'title': 'Nota vieja',
            'content': 'Contenido viejo',
            'category': 'Categoria vieja',
            'createdAt': DateTime.now(),
          });

      final noteId = docRef.id;

      // 2. Llamamos a updateNote
      final updatedNote = Note(
        id: noteId,
        title: 'Nota actualizada',
        content: 'Contenido actulizado',
        category: 'Nueva categoria',
        createdAt: DateTime.now(),
      );

      await noteRepository.updateNote(userId, updatedNote);

      // 3. Revisamos en Firestore simulado
      final snapshot =
          await fakeFirestore
              .collection('users')
              .doc(userId)
              .collection('notes')
              .doc(noteId)
              .get();

      expect(snapshot.data()?['title'], 'Nota actualizada');
      expect(snapshot.data()?['category'], 'Nueva categoria');
    });

    test("deleteNote elimina un documento existente", () async {
      //1. Creamos  un doc
      final docRef = await fakeFirestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .add({
            'title': 'Nota por borrar',
            'content': 'Contenido',
            'category': 'Cat',
            'createdAt': DateTime.now(),
          });
      final noteId = docRef.id;

      await noteRepository.deleteNote(userId, noteId);

      final snapshot =
          await fakeFirestore
              .collection('users')
              .doc(userId)
              .collection('notes')
              .doc(noteId)
              .get();

      expect(snapshot.exists, false);
    });
  });
}
