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

        // Refresh the notification history every
        // 5 seconds so new activity appears.
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

    // Make a separate copy so we do not change
    // the original list inside SafeStepsStore.
    final sortedNotifications =
        List<ActivityNotification>.from(
      store.notifications,
    );

    // Sort using the actual timestamp.
    //
    // Newest = largest DateTime
    // Oldest = smallest DateTime
    //
    // Therefore the newer notification is placed
    // before the older notification.
    sortedNotifications.sort(
      (a, b) {
        return b.createdAt.compareTo(
          a.createdAt,
        );
      },
    );

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
              sortedNotifications,
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

    return Column(
      children: [
        for (int i = 0;
            i < notifications.length;
            i++) ...[
          _ActivityNotice(
            notification: notifications[i],
          ),

          if (i < notifications.length - 1)
            const Divider(),
        ],
      ],
    );
  }
}

// ==========================================
// ACTIVITY NOTIFICATION
// ==========================================

class _ActivityNotice extends StatelessWidget {
  const _ActivityNotice({
    required this.notification,
  });

  final ActivityNotification notification;

  @override
  Widget build(BuildContext context) {
    final isCheckIn =
        notification.activityType == 'check_in';

    final title = isCheckIn
        ? '${notification.visitorName} checked in'
        : '${notification.visitorName} completed their visit';

    final icon = isCheckIn
        ? Icons.check_box_outlined
        : Icons.check_circle_outline;

    final iconColor =
        isCheckIn ? Colors.green : Colors.grey;

    // The database stores the timestamp as a
    // real DateTime. Convert it to the local
    // time of the computer/tablet/browser.
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

    final time =
        '$hour:$minute $period';

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,

      leading: Icon(
        icon,
        size: 20,
        color: iconColor,
      ),

      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),

      subtitle: Padding(
        padding: const EdgeInsets.only(
          top: 3,
        ),
        child: Text(
          '${notification.location} • $time',
        ),
      ),
    );
  }
}

// ==========================================
// MESSAGE
// ==========================================

class _Message extends StatelessWidget {
  const _Message({
    required this.name,
    required this.text,
  });

  final String name;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,

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
          fontWeight: FontWeight.w700,
        ),
      ),

      subtitle: Text(text),
    );
  }
}