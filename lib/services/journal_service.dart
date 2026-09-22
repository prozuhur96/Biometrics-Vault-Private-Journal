import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/journal_entry.dart';

class JournalService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _userEntriesRef() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User must be logged in to access journal entries.");
    }
    return _db.collection('users').doc(user.uid).collection('entries');
  }

  // CREATE: Write to local cache immediately and sync to cloud in background
  Future<void> addEntry(String title, String content) async {
    final now = DateTime.now();
    final newDoc = _userEntriesRef().doc();

    final entry = JournalEntry(
      id: newDoc.id,
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
    );

    // Unawaited or timed-out set ensures UI returns instantly
    newDoc.set(entry.toMap()).catchError((_) {});
  }

  // READ: Real-time stream
  Stream<List<JournalEntry>> getEntries() {
    return _userEntriesRef()
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => JournalEntry.fromMap(doc.id, doc.data()))
            .toList());
  }

  // UPDATE
  Future<void> updateEntry(String id, String title, String content) async {
    _userEntriesRef().doc(id).update({
      'title': title,
      'content': content,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    }).catchError((_) {});
  }

  // DELETE
  Future<void> deleteEntry(String id) async {
    _userEntriesRef().doc(id).delete().catchError((_) {});
  }
}