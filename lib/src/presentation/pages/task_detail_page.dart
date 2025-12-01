import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/task.dart';
import '../providers/providers.dart';

class TaskDetailPage extends ConsumerStatefulWidget {
  final String id;
  const TaskDetailPage({super.key, required this.id});
  @override
  ConsumerState<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends ConsumerState<TaskDetailPage> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    final repo = ref.read(inMemoryRepoProvider);
    repo.getById(widget.id).then((t) {
      if (t != null) {
        _titleCtrl.text = t.title;
        _descCtrl.text = t.description ?? '';
        setState(() { _completed = t.completed; });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(inMemoryRepoProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Task ${widget.id.substring(0,6)}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
          const SizedBox(height: 8),
          TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Description')),
          const SizedBox(height: 16),
          Row(children: [const Text('Completed'), Switch(value: _completed, onChanged: (v) => setState(() => _completed = v))]),
          const SizedBox(height: 16),
          Row(children: [
            ElevatedButton(onPressed: () async {
              final t = await repo.getById(widget.id);
              if (t != null) {
                final updated = t.copyWith(title: _titleCtrl.text, description: _descCtrl.text, completed: _completed, dirty: true);
                await repo.update(updated);
              }
              Navigator.of(context).pop();
            }, child: const Text('Save')),
            const SizedBox(width: 8),
            ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: () async {
              await repo.delete(widget.id);
              Navigator.of(context).pop();
            }, child: const Text('Delete'))
          ])
        ]),
      ),
    );
  }
}
