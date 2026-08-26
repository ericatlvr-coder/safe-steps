import 'package:flutter/material.dart';

import '../widgets/kiosk_shell.dart';
import 'checkin_form_screen.dart';
import 'login_screen.dart';
import 'terms_screen.dart';

class SignupTypeScreen extends StatelessWidget {
  const SignupTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KioskShell(
      child: Column(
        children: [
          const SizedBox(height: 52),
          const Text('Sign up as...', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 34),
          SizedBox(
            width: 250,
            child: FilledButton(
              onPressed: () => _go(context, const CheckInFormScreen(type: 'Individual')),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 13),
                child: Text('An individual', style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: 250,
            child: FilledButton(
              onPressed: () => _go(context, const CheckInFormScreen(type: 'Group')),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 13),
                child: Text('A group', style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
          const Spacer(),
          TermsLink(onTap: () => _go(context, const TermsScreen())),
          TextButton(
            onPressed: () => _go(context, const LoginScreen()),
            child: const Text('Been here before? Click here'),
          ),
        ],
      ),
    );
  }

  void _go(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}
