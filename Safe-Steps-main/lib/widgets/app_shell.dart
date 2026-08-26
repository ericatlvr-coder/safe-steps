import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../screens/admin_dashboard_screen.dart';
import '../screens/host_management_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/user_home_screen.dart';
import 'safe_steps_logo.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.body,
    this.title,
    this.showDrawer = true,
  });

  final Widget body;
  final String? title;
  final bool showDrawer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title == null ? const SafeStepsLogo() : Text(title!),
        centerTitle: title == null,
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
      ),
      drawer: showDrawer ? const SafeStepsDrawer() : null,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: body,
        ),
      ),
    );
  }
}

class SafeStepsDrawer extends StatelessWidget {
  const SafeStepsDrawer({super.key});

  void _go(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: SafeStepsColors.lime,
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Color(0xFF7A7A7A),
                    child: Icon(Icons.person, color: Colors.white, size: 36),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Hi, Emily!',
                    style: TextStyle(
                      color: SafeStepsColors.purple,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            _item(context, Icons.bookmark_border, 'Your activity Log', const UserHomeScreen()),
            _item(context, Icons.desktop_windows_outlined, 'Admin Dashboard', const AdminDashboardScreen()),
            _item(context, Icons.people_outline, 'Host Management', const HostManagementScreen()),
            _item(context, Icons.notifications_none, 'Notifications', const NotificationsScreen()),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                  style: FilledButton.styleFrom(
                    backgroundColor: SafeStepsColors.purple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Sign out'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String text, Widget screen) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(icon),
        title: Text(text),
        onTap: () => _go(context, screen),
      ),
    );
  }
}
