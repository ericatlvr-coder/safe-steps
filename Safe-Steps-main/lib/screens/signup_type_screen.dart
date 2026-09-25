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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 700;

          return Column(
            children: [
              SizedBox(
                height: isWide ? 70 : 52,
              ),

              Text(
                'Sign up as...',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: isWide ? 28 : 18,
                ),
              ),

              SizedBox(
                height: isWide ? 50 : 34,
              ),

              if (isWide)
                _LandscapeChoices(
                  onIndividual: () => _go(
                    context,
                    const CheckInFormScreen(
                      type: 'Individual',
                    ),
                  ),
                  onGroup: () => _go(
                    context,
                    const CheckInFormScreen(
                      type: 'Group',
                    ),
                  ),
                )
              else
                _PortraitChoices(
                  onIndividual: () => _go(
                    context,
                    const CheckInFormScreen(
                      type: 'Individual',
                    ),
                  ),
                  onGroup: () => _go(
                    context,
                    const CheckInFormScreen(
                      type: 'Group',
                    ),
                  ),
                ),

              const Spacer(),

              TermsLink(
                onTap: () => _go(
                  context,
                  const TermsScreen(),
                ),
              ),

              const SizedBox(height: 4),

              TextButton(
                onPressed: () => _go(
                  context,
                  const LoginScreen(),
                ),
                child: const Text(
                  'Been here before? Click here',
                ),
              ),

              const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }

  void _go(
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
// LANDSCAPE / TABLET / DESKTOP
// ============================================================

class _LandscapeChoices extends StatelessWidget {
  const _LandscapeChoices({
    required this.onIndividual,
    required this.onGroup,
  });

  final VoidCallback onIndividual;
  final VoidCallback onGroup;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 760,
        ),
        child: Row(
          children: [
            Expanded(
              child: _SignupButton(
                label: 'An individual',
                icon: Icons.person_outline,
                onPressed: onIndividual,
                large: true,
              ),
            ),

            const SizedBox(width: 28),

            Expanded(
              child: _SignupButton(
                label: 'A group',
                icon: Icons.groups_outlined,
                onPressed: onGroup,
                large: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SMALL / PORTRAIT
// ============================================================

class _PortraitChoices extends StatelessWidget {
  const _PortraitChoices({
    required this.onIndividual,
    required this.onGroup,
  });

  final VoidCallback onIndividual;
  final VoidCallback onGroup;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 250,
          child: _SignupButton(
            label: 'An individual',
            onPressed: onIndividual,
          ),
        ),

        const SizedBox(height: 18),

        SizedBox(
          width: 250,
          child: _SignupButton(
            label: 'A group',
            onPressed: onGroup,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// SIGN-UP BUTTON
// ============================================================

class _SignupButton extends StatelessWidget {
  const _SignupButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.large = false,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: large ? 115 : null,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              large ? 18 : 12,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: large ? 20 : 13,
            horizontal: large ? 16 : 0,
          ),
          child: large
              ? Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    if (icon != null)
                      Icon(
                        icon,
                        size: 32,
                      ),

                    if (icon != null)
                      const SizedBox(height: 10),

                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              : Text(
                  label,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
        ),
      ),
    );
  }
}