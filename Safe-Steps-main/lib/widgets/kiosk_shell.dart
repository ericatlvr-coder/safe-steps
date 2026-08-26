import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'safe_steps_logo.dart';

class KioskShell extends StatelessWidget {
  const KioskShell({
    super.key,
    required this.child,
    this.showLogo = true,
    this.panelTop = 92,
  });

  final Widget child;
  final bool showLogo;
  final double panelTop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SizedBox.expand(
            child: Stack(
              children: [
                const _AbstractBackground(),
                if (showLogo)
                  const Positioned(
                    top: 18,
                    left: 18,
                    child: SafeStepsLogo(light: true),
                  ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: panelTop,
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(34),
                      topRight: Radius.circular(34),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        color: Colors.white.withOpacity(0.79),
                        padding: const EdgeInsets.fromLTRB(28, 22, 28, 26),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class KioskHeader extends StatelessWidget {
  const KioskHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final now = TimeOfDay.now();
    final date = DateTime.now();
    final h = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.period == DayPeriod.am ? 'AM' : 'PM';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return Positioned(
      right: 18,
      top: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('$h:$minute $period', style: const TextStyle(color: Colors.white, fontSize: 12)),
          Text(
            '${date.day} ${months[date.month - 1]} ${date.year}',
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _AbstractBackground extends StatelessWidget {
  const _AbstractBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF274E36), Color(0xFF7D5D35), Color(0xFFE8E0D5)],
          stops: [0, 0.48, 1],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -70,
            right: -40,
            child: _blob(250, const Color(0xFFB6CE72).withOpacity(0.5)),
          ),
          Positioned(
            bottom: 80,
            left: -90,
            child: _blob(300, const Color(0xFFF0C3A7).withOpacity(0.46)),
          ),
          Positioned(
            bottom: -70,
            right: -30,
            child: _blob(250, Colors.white.withOpacity(0.38)),
          ),
        ],
      ),
    );
  }

  Widget _blob(double size, Color color) => ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      );
}

class TermsLink extends StatelessWidget {
  const TermsLink({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: onTap,
        child: const Text(
          'Terms and Conditions',
          style: TextStyle(
            color: SafeStepsColors.ink,
            decoration: TextDecoration.underline,
            fontSize: 12,
          ),
        ),
      );
}
