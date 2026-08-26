import 'package:flutter/material.dart';

import '../widgets/kiosk_shell.dart';
import 'admin_dashboard_screen.dart';
import 'terms_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _adminNumber = TextEditingController(text: 'admin');
  final _password = TextEditingController(text: 'admin123');
  String? error;

  @override
  void dispose() {
    _adminNumber.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KioskShell(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text('Log back in', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
            const SizedBox(height: 20),
            TextFormField(
              controller: _adminNumber,
              decoration: const InputDecoration(labelText: 'Admin Number'),
              validator: (value) => (value?.trim().isEmpty ?? true) ? 'Admin Number is required' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (value) => (value?.isEmpty ?? true) ? 'Password is required' : null,
            ),
            if (error != null) ...[
              const SizedBox(height: 12),
              Text(error!, style: const TextStyle(color: Colors.red)),
            ],
            const Spacer(),
            TermsLink(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsScreen()))),
            FilledButton(onPressed: _login, child: const Text('Log in', style: TextStyle(fontSize: 18))),
          ],
        ),
      ),
    );
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    if (_adminNumber.text.trim() != 'admin' || _password.text != 'admin123') {
      setState(() => error = 'Use admin / admin123 for the Iteration 1 prototype.');
      return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen()));
  }
}
