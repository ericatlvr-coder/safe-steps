import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../core/theme.dart';
import '../widgets/safe_steps_logo.dart';
import 'admin_login_screen.dart';
import 'checkout_screen.dart';
import 'login_screen.dart';
import 'signup_type_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1D3D2A), Color(0xFF745538), Color(0xFFE2D8CB)],
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0.2, sigmaY: 0.2),
                    child: const SizedBox(),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 26, 28, 16),
                    child: Column(
                      children: [
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                'Welcome\nto',
                                style: TextStyle(color: Colors.white, fontSize: 32, height: 1.12),
                              ),
                            ),
                            _ClockBlock(),
                          ],
                        ),
                        const Align(
                          alignment: Alignment(-0.34, 0),
                          child: SafeStepsLogo(light: true),
                        ),
                        const SizedBox(height: 14),
                        Divider(color: SafeStepsColors.lime.withOpacity(0.55)),
                        const SizedBox(height: 8),
                        const Text(
                          'Use QR codes below for contactless check-in/out',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _QrBlock(label: 'Check-in', data: 'safe-steps://checkin'),
                            _QrBlock(label: 'Check-out', data: 'safe-steps://checkout'),
                          ],
                        ),
                        const Spacer(),
                        const Text(
                          'If you wish to use this kiosk, proceed below',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _DarkButton(
                              label: 'Check-In',
                              onPressed: () => _push(context, const SignupTypeScreen()),
                            ),
                            const SizedBox(width: 26),
                            _DarkButton(
                              label: 'Check-Out',
                              onPressed: () => _push(context, const CheckoutScreen()),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () => _push(context, const LoginScreen()),
                              icon: const Icon(Icons.account_circle_outlined, color: Colors.white, size: 18),
                              label: const Text('Returning user', style: TextStyle(color: Colors.white, fontSize: 12)),
                            ),
                            TextButton.icon(
                              onPressed: () => _push(context, const AdminLoginScreen()),
                              icon: const Icon(Icons.admin_panel_settings_outlined, color: Colors.white, size: 18),
                              label: const Text('Admin', style: TextStyle(color: Colors.white, fontSize: 12)),
                            ),
                          ],
                        ),
                      ],
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

  void _push(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

class _ClockBlock extends StatelessWidget {
  const _ClockBlock();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('$hour:$minute $period', style: const TextStyle(color: Colors.white, fontSize: 12)),
        Text('${now.day} ${months[now.month - 1]} ${now.year}', style: const TextStyle(color: Colors.white, fontSize: 11)),
      ],
    );
  }
}

class _QrBlock extends StatelessWidget {
  const _QrBlock({required this.label, required this.data});
  final String label;
  final String data;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(4),
            child: QrImageView(data: data, size: 104, padding: EdgeInsets.zero),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      );
}

class _DarkButton extends StatelessWidget {
  const _DarkButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF252525),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(label),
      );
}
