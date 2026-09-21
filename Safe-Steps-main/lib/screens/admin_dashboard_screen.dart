import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/visitor.dart';
import '../state/safe_steps_store.dart';
import '../widgets/app_shell.dart';
import '../widgets/common.dart';
import 'make_entry_screen.dart';

class AdminDashboardScreen
    extends StatelessWidget {
  const AdminDashboardScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final store =
        SafeStepsScope.of(context);

    return AppShell(
      body: ListView(
        padding:
            const EdgeInsets.all(18),
        children: [
          const Align(
            alignment:
                Alignment.centerRight,
            child: Text(
              'Admin Dashboard',
              style: TextStyle(
                color:
                    SafeStepsColors.purple,
                fontSize: 23,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          SectionCard(
            padding:
                const EdgeInsets.fromLTRB(
              8,
              8,
              8,
              12,
            ),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection:
                      Axis.horizontal,
                  child: DataTable(
                    headingTextStyle:
                        const TextStyle(
                      color:
                          SafeStepsColors
                              .purple,
                      fontWeight:
                          FontWeight
                              .w700,
                    ),
                    columnSpacing: 24,
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Visitor Names',
                        ),
                      ),
                      DataColumn(
                        label:
                            Text('Type'),
                      ),
                      DataColumn(
                        label:
                            Text('Time'),
                      ),
                      DataColumn(
                        label:
                            Text('Purpose'),
                      ),
                      DataColumn(
                        label:
                            Text('Status'),
                      ),
                      DataColumn(
                        label:
                            Text('Edit'),
                      ),
                    ],
                    rows: store
                        .visitors
                        .reversed
                        .take(8)
                        .map(
                          (visitor) =>
                              _row(
                            context,
                            store,
                            visitor,
                          ),
                        )
                        .toList(),
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                Align(
                  alignment:
                      Alignment
                          .centerRight,
                  child:
                      FilledButton
                          .tonal(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const MakeEntryScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Make Entry',
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 22,
          ),

          LayoutBuilder(
            builder:
                (context, constraints) {
              final width =
                  constraints.maxWidth;

              final crossAxisCount =
                  width >= 650 ? 4 : 2;

              return GridView.count(
                crossAxisCount:
                    crossAxisCount,
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.6,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _metric(
                    'Current Visitors',
                    store.currentVisitors,
                  ),
                  _metric(
                    'Group Visitors',
                    store.groupVisitors,
                  ),
                  _metric(
                    'Flagged Visitors',
                    store.flaggedVisitors,
                  ),
                  _metric(
                    'Total Visits Today',
                    store.totalVisitsToday,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  DataRow _row(
    BuildContext context,
    SafeStepsStore store,
    Visitor visitor,
  ) {
    final isComplete =
        visitor.status ==
            'Complete';

    return DataRow(
      cells: [
        DataCell(
          Text(visitor.name),
        ),
        DataCell(
          Text(visitor.type),
        ),
        DataCell(
          Text(
            formatTime(
              visitor.checkIn,
            ),
          ),
        ),
        DataCell(
          Text(visitor.purpose),
        ),
        DataCell(
          StatusPill(
            label:
                visitor.status,
          ),
        ),

        DataCell(
          isComplete
              ? const Icon(
                  Icons.lock,
                  size: 20,
                  color:
                      Colors.grey,
                )
              : IconButton(
                  icon:
                      const Icon(
                    Icons.edit,
                    color:
                        SafeStepsColors
                            .purple,
                  ),
                  tooltip:
                      'Edit visitor status',
                  onPressed: () {
                    _showStatusDialog(
                      context,
                      store,
                      visitor,
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showStatusDialog(
    BuildContext context,
    SafeStepsStore store,
    Visitor visitor,
  ) {
    if (visitor.status ==
        'Complete') {
      return;
    }

    showDialog(
      context: context,
      builder:
          (dialogContext) {
        return AlertDialog(
          title: Text(
            'Update ${visitor.name}',
          ),
          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              const Text(
                'Change visitor status:',
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                'Current status: ${visitor.status}',
                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child:
                  const Text(
                'Cancel',
              ),
            ),

            TextButton(
              onPressed: () async {
                await store
                    .updateVisitorStatus(
                  visitor,
                  'Active',
                );

                if (dialogContext
                    .mounted) {
                  Navigator.pop(
                    dialogContext,
                  );
                }
              },
              child:
                  const Text(
                'Active',
              ),
            ),

            FilledButton(
              onPressed: () async {
                await store
                    .updateVisitorStatus(
                  visitor,
                  'Complete',
                );

                if (dialogContext
                    .mounted) {
                  Navigator.pop(
                    dialogContext,
                  );
                }
              },
              child:
                  const Text(
                'Complete',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _metric(
    String label,
    int value,
  ) {
    return SectionCard(
      padding:
          const EdgeInsets.all(
        12,
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment
                .center,
        children: [
          Text(
            '$value',
            style:
                const TextStyle(
              fontSize: 24,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            label,
            textAlign:
                TextAlign.center,
            style:
                const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}