import 'package:flutter/material.dart';

import '../widgets/kiosk_shell.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KioskShell(
      child: Column(
        children: [
          const Text('Terms and Conditions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFBFBFBF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const SingleChildScrollView(
                child: Text(
                  'Visitor Rules and Procedures\n\n'
                  'All visitors must check in via the kiosk, where they will be provided with a guest pass. This pass must be worn at all times while on site and be clearly visible.\n\n'
                  'Visitors must keep the site address and location confidential and must not disclose this information to anyone.\n\n'
                  'Visitors must not disclose any other confidential information, including taking unauthorised photos or recording audio or video without written consent from Safe Steps.\n\n'
                  'All visitors must check out via the kiosk upon departure.\n\n'
                  'Visitors should review the evacuation diagrams located around the site and follow all instructions issued by the Chief Warden in the event of an emergency.',
                  style: TextStyle(fontSize: 12, height: 1.35),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text('Back', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
