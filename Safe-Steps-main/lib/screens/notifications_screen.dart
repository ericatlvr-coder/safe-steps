import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/common.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const Text('Notifications', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 10),
          SectionCard(
            child: Column(
              children: const [
                _Notice(icon: Icons.warning_amber, text: 'Flagged visitor alert', trailing: 'Mark as seen'),
                Divider(),
                _Notice(icon: Icons.check_box_outlined, text: 'Jane Doe checked in'),
                Divider(),
                _Notice(icon: Icons.check_box_outlined, text: 'Organisation B is currently ongoing'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Messages', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 10),
          SectionCard(
            child: Column(
              children: const [
                _Message(name: 'Jane Doe', text: 'The counsellor is still ongoing.'),
                Divider(),
                _Message(name: 'John Smith', text: 'The team will see you soon.'),
                Divider(),
                _Message(name: 'Matt Denton', text: 'Do you mind checking on the meeting room?'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.text, this.trailing});
  final IconData icon;
  final String text;
  final String? trailing;

  @override
  Widget build(BuildContext context) => ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, size: 20, color: icon == Icons.warning_amber ? Colors.red : Colors.green),
        title: Text(text),
        trailing: trailing == null
            ? null
            : TextButton(onPressed: () {}, child: Text(trailing!, style: const TextStyle(fontSize: 10))),
      );
}

class _Message extends StatelessWidget {
  const _Message({required this.name, required this.text});
  final String name;
  final String text;

  @override
  Widget build(BuildContext context) => ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(
          radius: 15,
          backgroundColor: SafeStepsColors.purple,
          child: Icon(Icons.person, size: 18, color: Colors.white),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(text),
      );
}
