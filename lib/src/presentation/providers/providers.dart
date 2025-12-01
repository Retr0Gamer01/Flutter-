import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/in_memory_repo.dart';
import '../../data/api_service.dart';
import '../../services/sync_service.dart';
import 'task_list_notifier.dart';

final inMemoryRepoProvider = Provider((ref) => InMemoryTaskRepository());
final apiServiceProvider = Provider((ref) => ApiService());
final syncServiceProvider = Provider((ref) {
  final repo = ref.watch(inMemoryRepoProvider);
  final api = ref.watch(apiServiceProvider);
  final service = SyncService(repo: repo, api: api);
  service.start();
  ref.onDispose(() => service.dispose());
  return service;
});

final taskListNotifierProvider = StateNotifierProvider<TaskListNotifier, TaskListState>((ref) {
  final repo = ref.watch(inMemoryRepoProvider);
  return TaskListNotifier(repo);
});
