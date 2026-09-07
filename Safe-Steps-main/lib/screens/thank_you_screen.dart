import 'package:flutter/material.dart';

import '../widgets/kiosk_shell.dart';
import '../widgets/safe_steps_logo.dart';
import 'terms_screen.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KioskShell(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Text('Check out', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
          const Spacer(),
          const Text('Thank you for visiting SafeSteps', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 14),
          const SafeStepsLogo(),
          const Spacer(),
          TermsLink(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsScreen()))),
          FilledButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text('Finish', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
