import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../providers/task_list_notifier.dart';
import 'task_detail_page.dart';
import 'settings_page.dart'; // <-- ДОБАВЛЕНО

class TaskListPage extends ConsumerWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // запуск синхронизации
    ref.watch(syncServiceProvider);

    final state = ref.watch(taskListNotifierProvider);
    final notifier = ref.read(taskListNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planner+'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SettingsPage(), // <-- OK, const можно
                ),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // поле поиска
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search',
                    ),
                    onChanged: (v) {},
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // список задач
          Expanded(
            child: state.loading
                ? const Center(child: CircularProgressIndicator())
                : state.tasks.isEmpty
                    ? const Center(child: Text('No tasks yet'))
                    : ListView.separated(
                        itemCount: state.tasks.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final t = state.tasks[index];
                          return Dismissible(
                            key: ValueKey(t.id),
                            direction: DismissDirection.startToEnd,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.only(left: 16),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (_) =>
                                notifier.deleteTask(t.id),
                            child: ListTile(
                              title: Text(t.title),
                              subtitle: t.description == null
                                  ? null
                                  : Text(t.description!),
                              trailing: Checkbox(
                                value: t.completed,
                                onChanged: (_) =>
                                    notifier.toggleComplete(t.id),
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        TaskDetailPage(id: t.id),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final title = await showDialog<String>(
            context: context,
            builder: (ctx) {
              var v = '';
              return AlertDialog(
                title: const Text('New task'),
                content: TextField(
                  autofocus: true,
                  onChanged: (text) => v = text,
                ),
                actions: [
                  TextButton(
                    onPressed: () =>
                        Navigator.of(ctx).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(ctx).pop(v),
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );

          if (title != null && title.trim().isNotEmpty) {
            await notifier.addTask(title.trim());
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
