import 'package:flutter/material.dart';

import '../models/checkin_draft.dart';
import '../state/safe_steps_store.dart';
import '../widgets/app_shell.dart';

class MakeEntryScreen extends StatefulWidget {
  const MakeEntryScreen({super.key});

  @override
  State<MakeEntryScreen> createState() => _MakeEntryScreenState();
}

class _MakeEntryScreenState extends State<MakeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _contact = TextEditingController();
  final _purpose = TextEditingController();
  String type = 'Individual';
  String? hostId;
  bool busy = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _contact.dispose();
    _purpose.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = SafeStepsScope.of(context);
    return AppShell(
      title: 'Manual visitor entry',
      showDrawer: false,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            DropdownButtonFormField<String>(
              value: type,
              decoration: const InputDecoration(labelText: 'Visitor type'),
              items: const [
                DropdownMenuItem(value: 'Individual', child: Text('Individual')),
                DropdownMenuItem(value: 'Group', child: Text('Group')),
              ],
              onChanged: (value) => setState(() => type = value ?? 'Individual'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _name,
              decoration: InputDecoration(labelText: type == 'Group' ? 'Organisation name' : 'Full name'),
              validator: _required,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email address'),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return 'Required';
                if (!text.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(controller: _contact, decoration: const InputDecoration(labelText: 'Contact number'), validator: _required),
            const SizedBox(height: 12),
            TextFormField(controller: _purpose, decoration: const InputDecoration(labelText: 'Purpose of visit'), validator: _required),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: hostId,
              decoration: const InputDecoration(labelText: 'Host (from Entra ID)'),
              items: store.hosts
                  .map((host) => DropdownMenuItem(value: host.id, child: Text(host.displayName)))
                  .toList(),
              onChanged: (value) => setState(() => hostId = value),
            ),
            const SizedBox(height: 22),
            FilledButton(onPressed: busy ? null : _save, child: Text(busy ? 'Saving...' : 'Save entry')),
          ],
        ),
      ),
    );
  }

  String? _required(String? value) => (value?.trim().isEmpty ?? true) ? 'Required' : null;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => busy = true);
    final store = SafeStepsScope.of(context);
    final host = hostId == null
        ? null
        : store.hosts.where((h) => h.id == hostId).isEmpty
            ? null
            : store.hosts.firstWhere((h) => h.id == hostId);
    await store.checkIn(
      CheckInDraft(
        type: type,
        name: _name.text,
        email: _email.text,
        contactNumber: _contact.text,
        purpose: _purpose.text,
        location: store.currentLocation,
      ),
      host,
    );
    if (!mounted) return;
    Navigator.pop(context);
  }
}
