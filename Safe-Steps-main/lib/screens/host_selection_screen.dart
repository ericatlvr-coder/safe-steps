import 'package:flutter/material.dart';

import '../models/checkin_draft.dart';
import '../models/host.dart';
import '../state/safe_steps_store.dart';
import '../widgets/kiosk_shell.dart';
import 'terms_screen.dart';
import 'welcome_screen.dart';

class HostSelectionScreen extends StatefulWidget {
  const HostSelectionScreen({
    super.key,
    required this.draft,
  });

  final CheckInDraft draft;

  @override
  State<HostSelectionScreen> createState() =>
      _HostSelectionScreenState();
}

class _HostSelectionScreenState extends State<HostSelectionScreen> {
  Host? selected;
  bool otherSelected = false;
  bool saving = false;

  @override
  Widget build(BuildContext context) {
    final store = SafeStepsScope.of(context);

    // Display up to 5 hosts
    final hosts = store.hosts.take(5).toList();

    return KioskShell(
      child: Column(
        children: [
          const Text(
            'Please select the person you are here to meet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 12),

          // Show loading indicator while hosts are syncing
          if (store.hostSyncing)
            const LinearProgressIndicator(
              minHeight: 2,
            )

          // Show an error if host syncing fails
          else if (store.hostSyncError != null)
            Text(
              store.hostSyncError!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 11,
              ),
            ),

          const SizedBox(height: 8),

          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.15,
              children: [
                // Create host cards
                ...hosts.map(_hostCard),

                // Add the Other option
                _otherCard(),
              ],
            ),
          ),

          Text(
            'Hosts synced from ${store.hostSourceLabel}',
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black54,
            ),
          ),

          // Terms and Conditions link
          TermsLink(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TermsScreen(),
                ),
              );
            },
          ),

          // Finish button
          FilledButton(
            onPressed:
                saving || (selected == null && !otherSelected)
                    ? null
                    : _finish,
            child: Text(
              saving ? 'Saving...' : 'Finish',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Creates a card for each host
  Widget _hostCard(Host host) {
    final isSelected =
        selected?.id == host.id && !otherSelected;

    return InkWell(
      onTap: () {
        setState(() {
          selected = host;
          otherSelected = false;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFD2FFA1)
              : Colors.white.withOpacity(0.78),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6847FF)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xFFE1E1E1),
              child: Text(
                _initials(host.displayName),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
              ),
              child: Text(
                host.displayName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // Show host job title if available
            if (host.jobTitle != null)
              Text(
                host.jobTitle!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black54,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Creates the Other option card
  Widget _otherCard() {
    return InkWell(
      onTap: () {
        setState(() {
          selected = null;
          otherSelected = true;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: otherSelected
              ? const Color(0xFFD2FFA1)
              : Colors.white.withOpacity(0.78),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: otherSelected
                ? const Color(0xFF6847FF)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              child: Icon(Icons.more_horiz),
            ),

            SizedBox(height: 8),

            Text(
              'Other',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Creates initials for each host
  String _initials(String name) {
    final bits = name
        .trim()
        .split(RegExp(r'\s+'));

    if (bits.length == 1) {
      return bits.first
          .substring(0, 1)
          .toUpperCase();
    }

    return '${bits.first[0]}${bits.last[0]}'
        .toUpperCase();
  }

  // Called when the user presses Finish
  Future<void> _finish() async {
    setState(() {
      saving = true;
    });

    final store = SafeStepsScope.of(context);

    try {
      // Save the visitor check-in
      await store.checkIn(
        widget.draft,
        selected,
      );

      if (!mounted) return;

      // Return to the Welcome screen
      // and remove all previous screens
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
        ),
        (route) => false,
      );
    } catch (error) {
      if (!mounted) return;

      // Re-enable the button if saving fails
      setState(() {
        saving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to complete check-in: $error',
          ),
        ),
      );
    }
  }
}