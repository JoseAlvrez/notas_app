import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notas_app/models/note.dart';

class NoteRepository {
  final FirebaseFirestore _firestore;

  NoteRepository([FirebaseFirestore? firestore])
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Note>> getNotes(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList(),
        );
  }

  Future<void> addNote(String userId, Note note) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .add(note.toFirestore());
  }

  Future<void> updateNote(String userId, Note note) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(note.id)
        .update(note.toFirestore());
  }

  Future<void> deleteNote(String userId, String noteId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .delete();
  }
}
