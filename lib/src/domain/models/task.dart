// lib/src/domain/models/task.dart
// Simple Task model (plain Dart, null-safe)
class Task {
  final String id;
  String title;
  String? description;
  DateTime createdAt;
  DateTime updatedAt;
  bool completed;
  int priority;
  List<String> tags;
  bool dirty;
  bool deleted;
  String? remoteId;
  DateTime? lastSyncedAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.completed = false,
    this.priority = 1,
    List<String>? tags,
    this.dirty = true,
    this.deleted = false,
    this.remoteId,
    this.lastSyncedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        tags = tags ?? [];

  Task copyWith({
    String? title,
    String? description,
    bool? completed,
    int? priority,
    List<String>? tags,
    bool? dirty,
    bool? deleted,
    String? remoteId,
    DateTime? lastSyncedAt,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      completed: completed ?? this.completed,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      dirty: dirty ?? this.dirty,
      deleted: deleted ?? this.deleted,
      remoteId: remoteId ?? this.remoteId,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'completed': completed,
        'priority': priority,
        'tags': tags,
        'remoteId': remoteId,
        'lastSyncedAt': lastSyncedAt?.toIso8601String(),
      };

  static Task fromJson(Map<String, dynamic> m) {
    return Task(
      id: m['id'] as String,
      title: m['title'] as String,
      description: m['description'] as String?,
      createdAt: DateTime.tryParse(m['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(m['updatedAt'] ?? '') ?? DateTime.now(),
      completed: m['completed'] as bool? ?? false,
      priority: m['priority'] as int? ?? 1,
      tags: (m['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      remoteId: m['remoteId'] as String?,
      lastSyncedAt: DateTime.tryParse(m['lastSyncedAt'] ?? ''),
    );
  }
}
