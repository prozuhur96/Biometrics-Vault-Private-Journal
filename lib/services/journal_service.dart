import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/journal_entry.dart';

class JournalService {
  final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>>
      _userEntriesCollection() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'No authenticated user found. Please log in again.',
      );
    }

    return _db
        .collection('users')
        .doc(user.uid)
        .collection('entries');
  }

  Stream<List<JournalEntry>> getEntries() {
    return _userEntriesCollection()
        .orderBy(
          'updatedAt',
          descending: true,
        )
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => JournalEntry.fromMap(
              doc.id,
              doc.data(),
            ),
          )
          .toList();
    });
  }

  Future<void> addEntry(
    JournalEntry entry,
  ) async {
    await _userEntriesCollection().add(
      entry.toMap(),
    );
  }

  Future<void> updateEntry(
    String docId,
    JournalEntry entry,
  ) async {
    if (docId.isEmpty) {
      throw Exception(
        'Cannot update entry with empty document ID.',
      );
    }

    await _userEntriesCollection()
        .doc(docId)
        .update(
      entry.toMap(),
    );
  }

  Future<void> setEntryLock({
    required String docId,
    required bool isLocked,
    String pinHash = '',
    String pinSalt = '',
  }) async {
    if (docId.isEmpty) {
      throw Exception(
        'Cannot change lock on an entry with an empty document ID.',
      );
    }

    await _userEntriesCollection()
        .doc(docId)
        .update({
      'isLocked': isLocked,
      'pinHash': isLocked ? pinHash : '',
      'pinSalt': isLocked ? pinSalt : '',
      'updatedAt': Timestamp.fromDate(
        DateTime.now(),
      ),
    });
  }

  Future<void> deleteEntry(
    String docId,
  ) async {
    if (docId.isEmpty) return;

    await _userEntriesCollection()
        .doc(docId)
        .delete();
  }

  bool isSameColor(
    Color c1,
    Color c2,
  ) {
    return c1.toARGB32() ==
        c2.toARGB32();
  }

  BoxShadow getCardShadow(
    Color color,
  ) {
    return BoxShadow(
      color: color.withValues(
        alpha: 0.2,
      ),
      blurRadius: 4,
      offset: const Offset(0, 2),
    );
  }
}