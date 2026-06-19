import 'dart:math';
import 'package:flutter/material.dart';

class StarParticle {
  final double x; // 0.0–1.0 relative to canvas width
  final double y; // 0.0–1.0 relative to canvas height
  final double radius;
  final double phase; // twinkle phase offset 0.0–1.0
  final bool isGold; // ~5% of stars are gold-tinted

  const StarParticle({
    required this.x,
    required this.y,
    required this.radius,
    required this.phase,
    required this.isGold,
  });

  static List<StarParticle> generate(int count, {int seed = 42}) {
    final rng = Random(seed);
    final regular = List.generate(count, (_) => StarParticle(
          x: rng.nextDouble(),
          y: rng.nextDouble(),
          radius: rng.nextDouble() * 1.4 + 0.3,
          phase: rng.nextDouble(),
          isGold: rng.nextDouble() < 0.05,
        ));

    // A few large focal stars scattered across the canvas
    const bright = [
      StarParticle(x: 0.14, y: 0.11, radius: 3.0, phase: 0.10, isGold: true),
      StarParticle(x: 0.87, y: 0.07, radius: 3.4, phase: 0.60, isGold: false),
      StarParticle(x: 0.73, y: 0.82, radius: 2.8, phase: 0.30, isGold: true),
      StarParticle(x: 0.04, y: 0.54, radius: 2.5, phase: 0.80, isGold: false),
      StarParticle(x: 0.91, y: 0.44, radius: 3.1, phase: 0.45, isGold: true),
      StarParticle(x: 0.50, y: 0.06, radius: 2.6, phase: 0.20, isGold: false),
    ];

    return [...regular, ...bright];
  }
}

class StarfieldPainter extends CustomPainter {
  final List<StarParticle> stars;
  final double animationValue; // 0.0–1.0 looping

  const StarfieldPainter({
    required this.stars,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Subtle purple nebula radial gradient
    final nebulaRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final nebulaPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.2, -0.3),
        radius: 0.9,
        colors: [
          const Color(0xFF1A0A2E).withValues(alpha: 0.35),
          const Color(0xFF0A0A0F).withValues(alpha: 0.0),
        ],
      ).createShader(nebulaRect);
    canvas.drawRect(nebulaRect, nebulaPaint);

    // Second softer nebula on the opposite side
    final nebulaPaint2 = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.5, 0.5),
        radius: 0.7,
        colors: [
          const Color(0xFF0A1A2E).withValues(alpha: 0.2),
          const Color(0xFF0A0A0F).withValues(alpha: 0.0),
        ],
      ).createShader(nebulaRect);
    canvas.drawRect(nebulaRect, nebulaPaint2);

    // Draw stars
    for (final star in stars) {
      final x = star.x * size.width;
      final y = star.y * size.height;

      // Twinkle: opacity oscillates between 0.2 and 1.0 per star
      final twinkle = (sin((animationValue + star.phase) * 2 * pi) + 1) / 2;
      final opacity = 0.2 + 0.8 * twinkle;

      final color = star.isGold
          ? const Color(0xFFC9A84C).withValues(alpha: opacity * 0.9)
          : Colors.white.withValues(alpha: opacity * 0.75);

      final paint = Paint()
        ..color = color
        ..maskFilter = star.radius > 1.0
            ? MaskFilter.blur(BlurStyle.normal, star.radius * 0.6)
            : null;

      canvas.drawCircle(Offset(x, y), star.radius, paint);
    }
  }

  @override
  bool shouldRepaint(StarfieldPainter old) => old.animationValue != animationValue;
}
