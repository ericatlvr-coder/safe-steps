import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../state/safe_steps_store.dart';
import '../widgets/app_shell.dart';
import '../widgets/common.dart';
import 'location_picker_screen.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key, this.visitorEmail});

  final String? visitorEmail;

  @override
  Widget build(BuildContext context) {
    final store = SafeStepsScope.of(context);
    final visitor = visitorEmail == null ? null : store.findLatestByEmail(visitorEmail!);
    final name = visitor?.name ?? 'Emily Smith';
    final checkedInAt = visitor?.checkIn;

    return AppShell(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 40),
        children: [
          Text('Welcome,', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            '$name!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: SafeStepsColors.purple,
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_month_outlined, size: 18, color: Colors.redAccent),
              const SizedBox(width: 6),
              Text(formatDate(DateTime.now())),
              const SizedBox(width: 22),
              const Icon(Icons.access_time, size: 18, color: Color(0xFF888A50)),
              const SizedBox(width: 6),
              Text(formatTime(DateTime.now())),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(store.currentLocation, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LocationPickerScreen())),
                child: const Text('(Change?)', style: TextStyle(color: Color(0xFFFFA799))),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SectionCard(
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: SafeStepsColors.purple, size: 18),
                const SizedBox(width: 8),
                const Expanded(child: Text('Activity Log', style: TextStyle(color: SafeStepsColors.purple))),
                if (visitor != null) StatusPill(label: visitor.status),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SectionCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.done, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    checkedInAt == null
                        ? 'Prototype account ready'
                        : 'You checked-in at ${formatTime(checkedInAt)}',
                  ),
                ),
              ],
            ),
          ),
          if (visitor?.checkOut != null) ...[
            const SizedBox(height: 10),
            SectionCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.logout, size: 18),
                  const SizedBox(width: 8),
                  Text('You checked-out at ${formatTime(visitor!.checkOut!)}'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
