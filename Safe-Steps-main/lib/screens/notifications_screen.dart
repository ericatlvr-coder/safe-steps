import 'dart:async';

import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/activity_notification.dart';
import '../state/safe_steps_store.dart';
import '../widgets/app_shell.dart';
import '../widgets/common.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({
    super.key,
  });

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {
  Timer? _refreshTimer;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _refreshNotifications();

        _refreshTimer = Timer.periodic(
          const Duration(seconds: 5),
          (_) => _refreshNotifications(),
        );
      },
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _refreshNotifications() async {
    if (!mounted || _refreshing) {
      return;
    }

    _refreshing = true;

    try {
      final store =
          SafeStepsScope.of(context);

      await store.refreshNotifications();
    } catch (e) {
      debugPrint(
        'Could not refresh notifications: $e',
      );
    } finally {
      _refreshing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final store =
        SafeStepsScope.of(context);

    return AppShell(
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const Text(
            'Notifications',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 10),

          SectionCard(
            child: _buildNotifications(
              store.notifications,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Messages',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 10),

          const SectionCard(
            child: Column(
              children: [
                _Message(
                  name: 'Jane Doe',
                  text:
                      'The counsellor is still ongoing.',
                ),

                Divider(),

                _Message(
                  name: 'John Smith',
                  text:
                      'The team will see you soon.',
                ),

                Divider(),

                _Message(
                  name: 'Matt Denton',
                  text:
                      'Do you mind checking on the meeting room?',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // PERMANENT NOTIFICATION HISTORY
  // ==========================================

  Widget _buildNotifications(
    List<ActivityNotification> notifications,
  ) {
    if (notifications.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(
          vertical: 24,
        ),
        child: Center(
          child: Text(
            'No visitor activity yet.',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    // Group notification events by visitor.
    final Map<String, List<ActivityNotification>>
        grouped = {};

    for (final notification
        in notifications) {
      grouped
          .putIfAbsent(
            notification.visitorId,
            () => [],
          )
          .add(notification);
    }

    // Sort each visitor's events newest first.
    for (final events in grouped.values) {
      events.sort(
        (a, b) =>
            b.createdAt.compareTo(
          a.createdAt,
        ),
      );
    }

    // Sort visitors by their newest event.
    final groups =
        grouped.values.toList()
          ..sort(
            (a, b) =>
                b.first.createdAt.compareTo(
              a.first.createdAt,
            ),
          );

    // Flatten the groups.
    //
    // This keeps each visitor's activity
    // together while keeping the newest
    // visitor activity group first.
    final displayedNotifications =
        <ActivityNotification>[];

    for (final group in groups) {
      displayedNotifications.addAll(group);
    }

    final limitedNotifications =
        displayedNotifications
            .take(20)
            .toList();

    return Column(
      children: [
        for (int i = 0;
            i <
                limitedNotifications
                    .length;
            i++) ...[
          _ActivityNotice(
            notification:
                limitedNotifications[i],
          ),

          if (i <
              limitedNotifications
                      .length -
                  1)
            const Divider(),
        ],
      ],
    );
  }
}

// ============================================
// ACTIVITY NOTIFICATION
// ============================================

class _ActivityNotice
    extends StatelessWidget {
  const _ActivityNotice({
    required this.notification,
  });

  final ActivityNotification notification;

  @override
  Widget build(BuildContext context) {
    final isComplete =
        notification.activityType ==
            'complete';

    final String title;
    final IconData icon;
    final Color iconColor;

    if (isComplete) {
      title =
          '${notification.visitorName} '
          'completed their visit';

      icon =
          Icons.check_circle_outline;

      iconColor =
          Colors.grey;
    } else {
      title =
          '${notification.visitorName} '
          'checked in';

      icon =
          Icons.check_box_outlined;

      iconColor =
          Colors.green;
    }

    return ListTile(
      dense: true,
      contentPadding:
          EdgeInsets.zero,

      leading: Icon(
        icon,
        size: 20,
        color: iconColor,
      ),

      title: Text(
        title,
        style: const TextStyle(
          fontWeight:
              FontWeight.w600,
        ),
      ),

      subtitle: Padding(
        padding:
            const EdgeInsets.only(
          top: 3,
        ),
        child: Text(
          _activityDetails(
            notification,
          ),
        ),
      ),
    );
  }

  String _activityDetails(
    ActivityNotification notification,
  ) {
    final localTime =
        notification.createdAt.toLocal();

    final hour =
        localTime.hour % 12 == 0
            ? 12
            : localTime.hour % 12;

    final minute =
        localTime.minute
            .toString()
            .padLeft(2, '0');

    final period =
        localTime.hour >= 12
            ? 'PM'
            : 'AM';

    final location =
        notification.location.trim();

    if (location.isEmpty) {
      return '$hour:$minute $period';
    }

    return '$location • '
        '$hour:$minute $period';
  }
}

// ============================================
// DEMO MESSAGES
// ============================================

class _Message extends StatelessWidget {
  const _Message({
    required this.name,
    required this.text,
  });

  final String name;
  final String text;

  @override
  Widget build(
    BuildContext context,
  ) {
    return ListTile(
      dense: true,
      contentPadding:
          EdgeInsets.zero,

      leading: const CircleAvatar(
        radius: 15,
        backgroundColor:
            SafeStepsColors.purple,
        child: Icon(
          Icons.person,
          size: 18,
          color: Colors.white,
        ),
      ),

      title: Text(
        name,
        style: const TextStyle(
          fontWeight:
              FontWeight.w700,
        ),
      ),

      subtitle: Text(text),
    );
  }
}