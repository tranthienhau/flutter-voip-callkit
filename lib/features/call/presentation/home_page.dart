import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/call_service.dart';
import '../../../core/push_service.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _online = true;
  final _history = <_HistoryItem>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VoIP CallKit POC'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(children: [
              Text(_online ? 'Online' : 'Offline'),
              Switch(value: _online, onChanged: (v) => setState(() => _online = v)),
            ]),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _tokenCard('FCM token', PushService.instance.fcmToken),
          const SizedBox(height: 8),
          _tokenCard('iOS VoIP token (PushKit)', PushService.instance.voipToken),
          const SizedBox(height: 16),
          FilledButton.icon(
            icon: const Icon(Icons.phone_callback),
            label: const Text('Simulate incoming call'),
            onPressed: _simulate,
          ),
          const SizedBox(height: 16),
          Text('History', style: Theme.of(context).textTheme.titleMedium),
          for (final h in _history)
            ListTile(
              leading: Icon(h.accepted ? Icons.call_made : Icons.call_missed,
                  color: h.accepted ? Colors.green : Colors.red),
              title: Text(h.name),
              subtitle: Text(h.at.toLocal().toString()),
            ),
        ],
      ),
    );
  }

  Widget _tokenCard(String label, String? token) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              SelectableText(token ?? '(not available)'),
            ],
          ),
        ),
      );

  Future<void> _simulate() async {
    final id = const Uuid().v4();
    await CallService.instance.showIncomingFromData({
      'uuid': id,
      'handle': '+15551234567',
      'name': 'Test Partner',
      'deep_link': 'https://example.com/calls/$id',
    });
    setState(() => _history.insert(
        0, _HistoryItem(id, 'Test Partner', DateTime.now(), accepted: false)));
  }
}

class _HistoryItem {
  final String id;
  final String name;
  final DateTime at;
  final bool accepted;
  _HistoryItem(this.id, this.name, this.at, {required this.accepted});
}
