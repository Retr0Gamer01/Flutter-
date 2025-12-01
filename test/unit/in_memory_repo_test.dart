import 'package:flutter_test/flutter_test.dart';
import 'package:planner_plus/src/data/repositories/in_memory_repo.dart';
import 'package:planner_plus/src/domain/models/task.dart';

void main() {
  test('add and get task', () async {
    final repo = InMemoryTaskRepository();
    final t = Task(id: '1', title: 'Test');
    await repo.add(t);
    final all = await repo.getAll();
    expect(all.length, 1);
    expect(all.first.title, 'Test');
  });
}
