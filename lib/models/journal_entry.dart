import 'package:cloud_firestore/cloud_firestore.dart';

class JournalEntry {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  final bool isLocked;
  final String pinHash;
  final String pinSalt;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isLocked = false,
    this.pinHash = '',
    this.pinSalt = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isLocked': isLocked,
      'pinHash': pinHash,
      'pinSalt': pinSalt,
    };
  }

  factory JournalEntry.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return JournalEntry(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdAt:
          (map['createdAt'] as Timestamp?)
                  ?.toDate() ??
              DateTime.now(),
      updatedAt:
          (map['updatedAt'] as Timestamp?)
                  ?.toDate() ??
              DateTime.now(),
      isLocked: map['isLocked'] == true,
      pinHash: map['pinHash'] ?? '',
      pinSalt: map['pinSalt'] ?? '',
    );
  }

  JournalEntry copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isLocked,
    String? pinHash,
    String? pinSalt,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLocked: isLocked ?? this.isLocked,
      pinHash: pinHash ?? this.pinHash,
      pinSalt: pinSalt ?? this.pinSalt,
    );
  }
}