import 'package:flutter/material.dart';

import '../core/theme.dart';

class SafeStepsLogo extends StatelessWidget {
  const SafeStepsLogo({super.key, this.light = false, this.large = false});

  final bool light;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final bg = light ? SafeStepsColors.lime : SafeStepsColors.purple;
    final fg = light ? SafeStepsColors.purple : Colors.white;
    final size = large ? 22.0 : 16.0;
    return SizedBox(
      width: large ? 130 : 96,
      height: large ? 64 : 46,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 18,
            child: _chip('Safe', bg, fg, size),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: _chip('Steps', bg, fg, size),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, Color bg, Color fg, double fontSize) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: fg,
            fontSize: fontSize,
            height: 1,
            fontFamily: 'serif',
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}
