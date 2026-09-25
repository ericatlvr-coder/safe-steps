import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../core/theme.dart';
import '../widgets/safe_steps_logo.dart';
import 'admin_login_screen.dart';
import 'checkout_screen.dart';
import 'signup_type_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1D3D2A),
              Color(0xFF745538),
              Color(0xFFE2D8CB),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 0.2,
                  sigmaY: 0.2,
                ),
                child: const SizedBox(),
              ),
            ),

            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= 800) {
                    return _LandscapeWelcome(
                      onCheckIn: () => _push(
                        context,
                        const SignupTypeScreen(),
                      ),
                      onCheckOut: () => _push(
                        context,
                        const CheckoutScreen(),
                      ),
                      onAdmin: () => _push(
                        context,
                        const AdminLoginScreen(),
                      ),
                    );
                  }

                  return _PortraitWelcome(
                    onCheckIn: () => _push(
                      context,
                      const SignupTypeScreen(),
                    ),
                    onCheckOut: () => _push(
                      context,
                      const CheckoutScreen(),
                    ),
                    onAdmin: () => _push(
                      context,
                      const AdminLoginScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _push(
    BuildContext context,
    Widget screen,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }
}

// ============================================================
// LANDSCAPE / DESKTOP / TABLET
// ============================================================

class _LandscapeWelcome extends StatelessWidget {
  const _LandscapeWelcome({
    required this.onCheckIn,
    required this.onCheckOut,
    required this.onAdmin,
  });

  final VoidCallback onCheckIn;
  final VoidCallback onCheckOut;
  final VoidCallback onAdmin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 1200,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            48,
            24,
            48,
            20,
          ),
          child: Column(
            children: [
              // HEADER
              const Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Welcome\nto',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        height: 1.05,
                      ),
                    ),
                  ),
                  _ClockBlock(),
                ],
              ),

              const SizedBox(height: 4),

              const SafeStepsLogo(
                light: true,
              ),

              const SizedBox(height: 12),

              Divider(
                color:
                    SafeStepsColors.lime.withOpacity(
                  0.55,
                ),
              ),

              const SizedBox(height: 14),

              // QR SECTION
              const Text(
                'Use QR codes below for contactless check-in/out',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 16),

              const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  _QrBlock(
                    label: 'Check-in',
                    data: 'safe-steps://checkin',
                    size: 112,
                  ),

                  SizedBox(width: 70),

                  _QrBlock(
                    label: 'Check-out',
                    data: 'safe-steps://checkout',
                    size: 112,
                  ),
                ],
              ),

              const Spacer(),

              // KIOSK BUTTONS
              const Text(
                'If you wish to use this kiosk, proceed below',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 190,
                    child: _DarkButton(
                      label: 'Check-In',
                      onPressed: onCheckIn,
                      large: true,
                    ),
                  ),

                  const SizedBox(width: 24),

                  SizedBox(
                    width: 190,
                    child: _DarkButton(
                      label: 'Check-Out',
                      onPressed: onCheckOut,
                      large: true,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ADMIN ONLY
              Center(
                child: TextButton.icon(
                  onPressed: onAdmin,
                  icon: const Icon(
                    Icons.admin_panel_settings_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    'Admin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PORTRAIT / SMALL SCREEN
// ============================================================

class _PortraitWelcome extends StatelessWidget {
  const _PortraitWelcome({
    required this.onCheckIn,
    required this.onCheckOut,
    required this.onAdmin,
  });

  final VoidCallback onCheckIn;
  final VoidCallback onCheckOut;
  final VoidCallback onAdmin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 520,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            28,
            26,
            28,
            16,
          ),
          child: Column(
            children: [
              const Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Welcome\nto',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        height: 1.12,
                      ),
                    ),
                  ),
                  _ClockBlock(),
                ],
              ),

              const Align(
                alignment: Alignment(-0.34, 0),
                child: SafeStepsLogo(
                  light: true,
                ),
              ),

              const SizedBox(height: 14),

              Divider(
                color:
                    SafeStepsColors.lime.withOpacity(
                  0.55,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Use QR codes below for contactless check-in/out',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 18),

              const Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                children: [
                  _QrBlock(
                    label: 'Check-in',
                    data: 'safe-steps://checkin',
                  ),
                  _QrBlock(
                    label: 'Check-out',
                    data: 'safe-steps://checkout',
                  ),
                ],
              ),

              const Spacer(),

              const Text(
                'If you wish to use this kiosk, proceed below',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  _DarkButton(
                    label: 'Check-In',
                    onPressed: onCheckIn,
                  ),

                  const SizedBox(width: 26),

                  _DarkButton(
                    label: 'Check-Out',
                    onPressed: onCheckOut,
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Center(
                child: TextButton.icon(
                  onPressed: onAdmin,
                  icon: const Icon(
                    Icons.admin_panel_settings_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text(
                    'Admin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// CLOCK
// ============================================================

class _ClockBlock extends StatelessWidget {
  const _ClockBlock();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final hour =
        now.hour % 12 == 0
            ? 12
            : now.hour % 12;

    final minute =
        now.minute
            .toString()
            .padLeft(2, '0');

    final period =
        now.hour >= 12
            ? 'PM'
            : 'AM';

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.end,
      children: [
        Text(
          '$hour:$minute $period',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        Text(
          '${now.day} ${months[now.month - 1]} ${now.year}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// QR BLOCK
// ============================================================

class _QrBlock extends StatelessWidget {
  const _QrBlock({
    required this.label,
    required this.data,
    this.size = 104,
  });

  final String label;
  final String data;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(4),
          child: QrImageView(
            data: data,
            size: size,
            padding: EdgeInsets.zero,
          ),
        ),

        const SizedBox(height: 7),

        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// DARK BUTTON
// ============================================================

class _DarkButton extends StatelessWidget {
  const _DarkButton({
    required this.label,
    required this.onPressed,
    this.large = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: large ? 54 : null,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor:
              const Color(0xFF252525),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: large ? 28 : 22,
            vertical: large ? 14 : 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: large ? 16 : 14,
            fontWeight: large
                ? FontWeight.w600
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}