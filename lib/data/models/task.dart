/// Data model for a Task.
class Task {
  final int? id;
  final String title;
  final String? description;
  final String? priority; // HIGH, ROUTINE
  final bool isCompleted;
  final String date; // yyyy-MM-dd
  final int attachmentCount;
  final DateTime createdAt;

  const Task({
    this.id,
    required this.title,
    this.description,
    this.priority,
    this.isCompleted = false,
    required this.date,
    this.attachmentCount = 0,
    required this.createdAt,
  });

  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? priority,
    bool? isCompleted,
    String? date,
    int? attachmentCount,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
      attachmentCount: attachmentCount ?? this.attachmentCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'isCompleted': isCompleted ? 1 : 0,
      'date': date,
      'attachmentCount': attachmentCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String?,
      priority: map['priority'] as String?,
      isCompleted: (map['isCompleted'] as int) == 1,
      date: map['date'] as String,
      attachmentCount: (map['attachmentCount'] as int?) ?? 0,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
