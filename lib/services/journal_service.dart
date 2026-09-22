import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/journal_entry.dart';

class JournalService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Helper to get current user's document collection path
  CollectionReference<Map<String, dynamic>> _userEntriesRef() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User must be logged in to access journal entries.");
    }
    return _db.collection('users').doc(user.uid).collection('entries');
  }

  // CREATE: Add a new journal entry
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

    await newDoc.set(entry.toMap());
  }

  // READ: Stream real-time list of journal entries (sorted by newest first)
  Stream<List<JournalEntry>> getEntries() {
    return _userEntriesRef()
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => JournalEntry.fromMap(doc.id, doc.data()))
            .toList());
  }

  // UPDATE: Modify an existing entry
  Future<void> updateEntry(String id, String title, String content) async {
    await _userEntriesRef().doc(id).update({
      'title': title,
      'content': content,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  // DELETE: Remove an entry
  Future<void> deleteEntry(String id) async {
    await _userEntriesRef().doc(id).delete();
  }
}