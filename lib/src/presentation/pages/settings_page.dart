import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(children: [
        ListTile(title: const Text('Theme'), subtitle: const Text('Light / Dark (system)')),
        ListTile(title: const Text('Language'), subtitle: const Text('English / Russian')),
        ListTile(title: const Text('Sync account'), subtitle: const Text('Demo server')),
      ]),
    );
  }
}
