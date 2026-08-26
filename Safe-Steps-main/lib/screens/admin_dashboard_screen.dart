import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/visitor.dart';
import '../state/safe_steps_store.dart';
import '../widgets/app_shell.dart';
import '../widgets/common.dart';
import 'make_entry_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = SafeStepsScope.of(context);
    return AppShell(
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Admin Dashboard',
              style: TextStyle(color: SafeStepsColors.purple, fontSize: 23, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 12),
          SectionCard(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingTextStyle: const TextStyle(color: SafeStepsColors.purple, fontWeight: FontWeight.w700),
                    columnSpacing: 24,
                    columns: const [
                      DataColumn(label: Text('Visitor Names')),
                      DataColumn(label: Text('Type')),
                      DataColumn(label: Text('Time')),
                      DataColumn(label: Text('Purpose')),
                      DataColumn(label: Text('Status')),
                    ],
                    rows: store.visitors.reversed.take(8).map(_row).toList(),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.tonal(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MakeEntryScreen())),
                    child: const Text('Make Entry'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final crossAxisCount = width >= 650 ? 4 : 2;
              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.6,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _metric('Current Visitors', store.currentVisitors),
                  _metric('Group Visitors', store.groupVisitors),
                  _metric('Flagged Visitors', store.flaggedVisitors),
                  _metric('Total Visits Today', store.totalVisitsToday),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  DataRow _row(Visitor visitor) => DataRow(cells: [
        DataCell(Text(visitor.name)),
        DataCell(Text(visitor.type)),
        DataCell(Text(formatTime(visitor.checkIn))),
        DataCell(Text(visitor.purpose)),
        DataCell(StatusPill(label: visitor.status)),
      ]);

  Widget _metric(String label, int value) => SectionCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$value', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
          ],
        ),
      );
}
