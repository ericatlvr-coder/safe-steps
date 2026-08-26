import 'package:flutter/material.dart';

import '../state/safe_steps_store.dart';
import '../widgets/kiosk_shell.dart';
import 'terms_screen.dart';
import 'thank_you_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool busy = false;
  String? error;

  @override
  void dispose() {
    _email.dispose();
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
            const Text('Check out', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
            const SizedBox(height: 20),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email Address'),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return 'Email Address is required';
                if (!text.contains('@') || !text.contains('.')) return 'Enter a valid email address';
                return null;
              },
            ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'No password is required at checkout.',
                style: TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ),
            if (error != null) ...[
              const SizedBox(height: 12),
              Text(error!, style: const TextStyle(color: Colors.red)),
            ],
            const Spacer(),
            TermsLink(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsScreen()))),
            FilledButton(
              onPressed: busy ? null : _checkout,
              child: Text(busy ? 'Checking...' : 'Next', style: const TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkout() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      busy = true;
      error = null;
    });
    final ok = await SafeStepsScope.of(context).checkOutByEmail(_email.text);
    if (!mounted) return;
    if (!ok) {
      setState(() {
        busy = false;
        error = 'No active visit was found for this email address.';
      });
      return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ThankYouScreen()));
  }
}
