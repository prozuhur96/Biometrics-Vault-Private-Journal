import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/journal_entry.dart';
import 'encryption_service.dart';

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

  // CREATE: Encrypt title & content before writing
  Future<void> addEntry(String title, String content) async {
    final now = DateTime.now();
    final newDoc = _userEntriesRef().doc();

    final encryptedTitle = EncryptionService.encryptText(title);
    final encryptedContent = EncryptionService.encryptText(content);

    final entry = JournalEntry(
      id: newDoc.id,
      title: encryptedTitle,
      content: encryptedContent,
      createdAt: now,
      updatedAt: now,
    );

    newDoc.set(entry.toMap()).catchError((_) {});
  }

  // READ: Stream and decrypt entries automatically
  Stream<List<JournalEntry>> getEntries() {
    return _userEntriesRef()
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final rawEntry = JournalEntry.fromMap(doc.id, doc.data());
              return JournalEntry(
                id: rawEntry.id,
                title: EncryptionService.decryptText(rawEntry.title),
                content: EncryptionService.decryptText(rawEntry.content),
                createdAt: rawEntry.createdAt,
                updatedAt: rawEntry.updatedAt,
              );
            }).toList());
  }

  // UPDATE: Encrypt updated title & content
  Future<void> updateEntry(String id, String title, String content) async {
    final encryptedTitle = EncryptionService.encryptText(title);
    final encryptedContent = EncryptionService.encryptText(content);

    _userEntriesRef().doc(id).update({
      'title': encryptedTitle,
      'content': encryptedContent,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    }).catchError((_) {});
  }

  // DELETE: Remove entry
  Future<void> deleteEntry(String id) async {
    _userEntriesRef().doc(id).delete().catchError((_) {});
  }
}