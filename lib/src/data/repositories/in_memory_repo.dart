import '../../domain/models/task.dart';

class InMemoryTaskRepository {
  final Map<String, Task> _map = {};

  Future<List<Task>> getAll() async => _map.values.where((t) => !t.deleted).toList();

  Future<Task?> getById(String id) async => _map[id];

  Future<void> add(Task t) async {
    _map[t.id] = t;
  }

  Future<void> update(Task t) async {
    _map[t.id] = t;
  }

  Future<void> delete(String id) async {
    final t = _map[id];
    if (t != null) {
      t.deleted = true;
      t.dirty = true;
    }
  }

  Future<List<Task>> getDirty() async => _map.values.where((t) => t.dirty && !t.deleted).toList();

  Future<void> markSynced(String id, {String? remoteId}) async {
    final t = _map[id];
    if (t != null) {
      t.dirty = false;
      t.remoteId = remoteId ?? t.remoteId;
      t.lastSyncedAt = DateTime.now();
    }
  }
}
