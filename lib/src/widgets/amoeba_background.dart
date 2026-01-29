import 'package:flutter/material.dart';
import 'package:nocturnal_onboarding/src/theme/tutorials_theme.dart';
import 'package:nocturnal_onboarding/src/utils/amoeba_painter.dart';

class AmoebaBackground extends StatefulWidget {
  const AmoebaBackground({super.key});

  @override
  State<AmoebaBackground> createState() => _AmoebaBackgroundState();
}

class _AmoebaBackgroundState extends State<AmoebaBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: AmoebaPainter(animationValue: _controller.value),
          child: Container(color: TutorialsTheme.backgroundColor),
        );
      },
    );
  }
}
