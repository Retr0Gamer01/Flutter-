import 'dart:async';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../data/api_service.dart';
import '../data/repositories/in_memory_repo.dart';
import '../domain/models/task.dart';

class SyncService {
  final InMemoryTaskRepository repo;
  final ApiService api;
  final Connectivity _connectivity;
  StreamSubscription<ConnectivityResult>? _connSub;
  bool _running = false;

  SyncService({required this.repo, required this.api, Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  void start() {
    _connSub = _connectivity.onConnectivityChanged.listen((res) {
      if (res != ConnectivityResult.none) {
        _trySync();
      }
    });
    _trySync();
  }

  Future<void> _trySync() async {
    if (_running) return;
    _running = true;
    try {
      final dirty = await repo.getDirty();
      for (final t in dirty) {
        await _pushWithRetry(t);
      }
    } finally {
      _running = false;
    }
  }

  Future<void> _pushWithRetry(Task t, {int attempts = 0}) async {
    const maxAttempts = 3;
    try {
      if (t.remoteId == null) {
        final res = await api.createTask(t.toJson());
        await repo.markSynced(t.id, remoteId: res['remoteId'] ?? res['id']);
      } else {
        final res = await api.updateTask(t.remoteId!, t.toJson());
        await repo.markSynced(t.id, remoteId: res['id'] ?? t.remoteId);
      }
    } catch (e) {
      if (attempts < maxAttempts) {
        final delay = pow(2, attempts) * 1000;
        await Future.delayed(Duration(milliseconds: delay.toInt()));
        await _pushWithRetry(t, attempts: attempts + 1);
      } else {
        // leave dirty = true; will retry later
      }
    }
  }

  void dispose() => _connSub?.cancel();
}
