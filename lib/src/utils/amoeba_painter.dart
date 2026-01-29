import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nocturnal_onboarding/src/theme/tutorials_theme.dart';

class AmoebaPainter extends CustomPainter {
  final double animationValue;

  AmoebaPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < TutorialsTheme.blobColors.length; i++) {
      _drawBlob(canvas, size, i);
    }
  }

  void _drawBlob(Canvas canvas, Size size, int blobIndex) {
    final paint = Paint()
      ..color = TutorialsTheme.blobColors[blobIndex]
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40)
      ..style = PaintingStyle.fill;

    final path = _generateBlobPath(size, blobIndex);
    canvas.drawPath(path, paint);
  }

  Path _generateBlobPath(Size size, int blobIndex) {
    final path = Path();
    final centerX = size.width * (0.3 + 0.15 * blobIndex);
    final centerY = size.height * (0.3 + 0.1 * blobIndex);
    final baseRadius = size.width * (0.25 + 0.05 * blobIndex);

    const numPoints = 8;
    final phaseOffset = blobIndex * pi / 3;

    for (int i = 0; i <= numPoints; i++) {
      final angle = (2 * pi * i / numPoints);
      final radiusVariation = sin(
                animationValue * 2 * pi + angle * 2 + phaseOffset,
              ) *
              baseRadius *
              0.2 +
          cos(animationValue * 2 * pi * 1.5 + angle * 3 + phaseOffset) *
              baseRadius *
              0.1;

      final radius = baseRadius + radiusVariation;
      final x = centerX + radius * cos(angle);
      final y = centerY + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        // Use quadratic bezier for smooth organic curves
        final prevAngle = (2 * pi * (i - 1) / numPoints);
        final midAngle = (prevAngle + angle) / 2;
        final controlRadius = baseRadius * 1.15 +
            sin(animationValue * 2 * pi * 0.7 + midAngle + phaseOffset) *
                baseRadius *
                0.15;
        final cx = centerX + controlRadius * cos(midAngle);
        final cy = centerY + controlRadius * sin(midAngle);
        path.quadraticBezierTo(cx, cy, x, y);
      }
    }

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(AmoebaPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
