import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../state/safe_steps_store.dart';
import '../widgets/app_shell.dart';
import '../widgets/common.dart';

class HostManagementScreen extends StatelessWidget {
  const HostManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = SafeStepsScope.of(context);
    return AppShell(
      body: RefreshIndicator(
        onRefresh: store.syncHosts,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Host Management',
                        style: TextStyle(color: SafeStepsColors.purple, fontSize: 24, fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: 4),
                      Text('Hosts are read from Entra ID; no separate host database is maintained.'),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: 'Sync now',
                  onPressed: store.hostSyncing ? null : store.syncHosts,
                  icon: store.hostSyncing
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.sync),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SectionCard(
              child: Row(
                children: [
                  const Icon(Icons.cloud_done_outlined, color: SafeStepsColors.purple),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Source: ${store.hostSourceLabel}\n'
                      'Last sync: ${store.lastHostSync == null ? 'Not yet synced' : '${formatDate(store.lastHostSync!)} ${formatTime(store.lastHostSync!)}'}',
                    ),
                  ),
                ],
              ),
            ),
            if (store.hostSyncError != null) ...[
              const SizedBox(height: 12),
              MaterialBanner(
                content: Text(store.hostSyncError!),
                leading: const Icon(Icons.error_outline, color: Colors.red),
                actions: [TextButton(onPressed: store.syncHosts, child: const Text('Retry'))],
              ),
            ],
            const SizedBox(height: 16),
            ...store.hosts.map(
              (host) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SectionCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: SafeStepsColors.lime,
                      child: Text(_initials(host.displayName)),
                    ),
                    title: Text(host.displayName, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text('${host.jobTitle ?? 'Host'}\n${host.email}'),
                    isThreeLine: true,
                    trailing: const Tooltip(
                      message: 'Managed in Entra ID',
                      child: Icon(Icons.lock_outline),
                    ),
                  ),
                ),
              ),
            ),
            if (store.hosts.isEmpty && !store.hostSyncing)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: Text('No hosts were returned by Entra ID.')),
              ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final bits = name.trim().split(RegExp(r'\s+'));
    if (bits.isEmpty || bits.first.isEmpty) return '?';
    if (bits.length == 1) return bits.first[0].toUpperCase();
    return '${bits.first[0]}${bits.last[0]}'.toUpperCase();
  }
}
