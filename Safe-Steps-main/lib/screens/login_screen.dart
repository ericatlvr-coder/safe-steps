import 'package:flutter/material.dart';

import '../state/safe_steps_store.dart';
import '../widgets/kiosk_shell.dart';
import 'terms_screen.dart';
import 'user_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: 'emily@demo.local');
  final _password = TextEditingController(text: 'demo123');
  String? error;

  @override
  void dispose() {
    _email.dispose();
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
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email Address'),
              validator: (value) => (value?.trim().isEmpty ?? true) ? 'Email is required' : null,
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
            FilledButton(
              onPressed: _login,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text('Next', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    if (_password.text != 'demo123') {
      setState(() => error = 'For the prototype, use password demo123.');
      return;
    }
    final visitor = SafeStepsScope.of(context).findLatestByEmail(_email.text);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => UserHomeScreen(visitorEmail: visitor?.email ?? _email.text.trim()),
      ),
    );
  }
}
