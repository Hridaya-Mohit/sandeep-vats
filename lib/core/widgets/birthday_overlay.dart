import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

// ── Check if today is Sandeep's birthday (June 19) ────────────────────────────

bool get isBirthday {
  final now = DateTime.now();
  return now.month == 6 && now.day == 19;
}

// ── Confetti Particle ─────────────────────────────────────────────────────────

class _Particle {
  final double x;        // 0–1 horizontal position
  final double startY;   // starting vertical offset
  final double speed;    // fall speed multiplier
  final double drift;    // horizontal drift per cycle
  final double rotation; // initial rotation
  final double rotSpeed; // rotation speed
  final double width;    // particle width
  final double height;   // particle height
  final Color color;

  const _Particle({
    required this.x,
    required this.startY,
    required this.speed,
    required this.drift,
    required this.rotation,
    required this.rotSpeed,
    required this.width,
    required this.height,
    required this.color,
  });

  static List<_Particle> generate(int count) {
    final rng = Random();
    // Festive colors — intentionally distinct from gold theme
    const colors = [
      Color(0xFFFF4B6E), // hot pink
      Color(0xFF4FC3F7), // sky blue
      Color(0xFF81C784), // soft green
      Color(0xFFFFB74D), // orange
      Color(0xFFCE93D8), // lavender
      Color(0xFFFFFFFF), // white
      Color(0xFFFF8A65), // coral
      Color(0xFF4DB6AC), // teal
    ];

    return List.generate(count, (i) {
      // Even horizontal spread: divide into columns with small random jitter
      final baseX = i / count;
      return _Particle(
        x: (baseX + (rng.nextDouble() - 0.5) * (1.0 / count)).clamp(0.0, 1.0),
        startY: rng.nextDouble() * 1.15, // spread across full screen initially
        speed: 0.6 + rng.nextDouble() * 0.7, // 0.6–1.3 → slightly relaxed fall
        drift: (rng.nextDouble() - 0.5) * 0.03,
        rotation: rng.nextDouble() * pi * 2,
        rotSpeed: (rng.nextDouble() - 0.5) * 6,
        width: 6 + rng.nextDouble() * 7,
        height: 3 + rng.nextDouble() * 5,
        color: colors[rng.nextInt(colors.length)],
      );
    });
  }
}

// ── Confetti Painter ──────────────────────────────────────────────────────────

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double animValue;

  _ConfettiPainter({required this.particles, required this.animValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final currentY = ((p.startY + animValue * p.speed) % 1.15);
      if (currentY < 0) continue;

      final px = (p.x + animValue * p.drift) * size.width;
      final py = currentY * size.height;

      // Fade in at top, fade out at bottom
      double opacity = 1.0;
      if (currentY < 0.05) opacity = currentY / 0.05;
      if (currentY > 0.88) opacity = (1.0 - currentY) / 0.12;
      opacity = opacity.clamp(0.0, 1.0) * 0.85;

      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(p.rotation + animValue * p.rotSpeed);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: p.width, height: p.height),
          const Radius.circular(1),
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.animValue != animValue;
}

// ── Birthday Overlay (confetti + banner, shared dismiss) ─────────────────────

class BirthdayOverlay extends StatefulWidget {
  const BirthdayOverlay({super.key});

  @override
  State<BirthdayOverlay> createState() => _BirthdayOverlayState();
}

class _BirthdayOverlayState extends State<BirthdayOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final _particles = _Particle.generate(100);
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _dismiss() {
    _ctrl.stop();
    setState(() => _dismissed = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();

    return Stack(
      children: [
        // Confetti layer — full screen, pointer events ignored
        IgnorePointer(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (ctx, _) => CustomPaint(
                painter: _ConfettiPainter(
                  particles: _particles,
                  animValue: _ctrl.value,
                ),
                size: Size.infinite,
              ),
            ),
          ),
        ),
        // Banner — sticky below navbar
        Positioned(
          top: 72, left: 0, right: 0,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gold.withValues(alpha: 0.15),
                  AppColors.gold.withValues(alpha: 0.08),
                  AppColors.gold.withValues(alpha: 0.15),
                ],
              ),
              border: const Border(
                bottom: BorderSide(color: AppColors.borderGold, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                const Spacer(),
                Flexible(
                  child: Text(
                    '🎂  Happy Birthday, Jyotishacharya Pt. Sandeep Vats Ji  ✦  Wishing you a blessed and joyous birthday!',
                    style: AppTextStyles.inter(
                      fontSize: 12,
                      color: AppColors.gold,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _dismiss,
                  child: const Icon(Icons.close, size: 14, color: AppColors.goldMuted),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
