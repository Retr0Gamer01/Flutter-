import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/task.dart';
import '../../data/repositories/in_memory_repo.dart';
import 'package:uuid/uuid.dart';

class TaskListState {
  final List<Task> tasks;
  final bool loading;
  TaskListState({required this.tasks, this.loading = false});

  TaskListState copyWith({List<Task>? tasks, bool? loading}) => TaskListState(tasks: tasks ?? this.tasks, loading: loading ?? this.loading);
}

class TaskListNotifier extends StateNotifier<TaskListState> {
  final InMemoryTaskRepository repo;
  TaskListNotifier(this.repo): super(TaskListState(tasks: [])) {
    _load();
  }

  Future<void> _load() async {
    state = state.copyWith(loading: true);
    final all = await repo.getAll();
    state = state.copyWith(tasks: all, loading: false);
  }

  Future<void> addTask(String title) async {
    final id = const Uuid().v4();
    final t = Task(id: id, title: title);
    await repo.add(t);
    await _load();
  }

  Future<void> toggleComplete(String id) async {
    final t = await repo.getById(id);
    if (t==null) return;
    final updated = t.copyWith(completed: !t.completed, dirty: true);
    await repo.update(updated);
    await _load();
  }

  Future<void> deleteTask(String id) async {
    await repo.delete(id);
    await _load();
  }
}
