/// Data model for a Note.
class Note {
  final int? id;
  final String title;
  final String body;
  final String? category; // WORK, URGENT, CREATIVE
  final bool isPinned;
  final String? headerImagePath;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
    this.id,
    required this.title,
    required this.body,
    this.category,
    this.isPinned = false,
    this.headerImagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  Note copyWith({
    int? id,
    String? title,
    String? body,
    String? category,
    bool? isPinned,
    String? headerImagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      category: category ?? this.category,
      isPinned: isPinned ?? this.isPinned,
      headerImagePath: headerImagePath ?? this.headerImagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'body': body,
      'category': category,
      'isPinned': isPinned ? 1 : 0,
      'headerImagePath': headerImagePath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String,
      body: map['body'] as String,
      category: map['category'] as String?,
      isPinned: (map['isPinned'] as int) == 1,
      headerImagePath: map['headerImagePath'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}
