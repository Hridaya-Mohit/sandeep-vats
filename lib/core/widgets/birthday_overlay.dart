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
  final double startY;   // starting vertical offset (-0.3 to 0)
  final double speed;    // fall speed multiplier
  final double drift;    // horizontal drift per cycle
  final double rotation; // initial rotation
  final double rotSpeed; // rotation speed
  final double width;    // particle width
  final double height;   // particle height
  final Color color;
  final bool isCircle;

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
    required this.isCircle,
  });

  static List<_Particle> generate(int count) {
    final rng = Random(42);
    final colors = [
      AppColors.gold,
      AppColors.goldLight,
      const Color(0xFFF2EDD8), // cream
      const Color(0xFF8B1A2A), // deep maroon
      AppColors.goldMuted,
      const Color(0xFFE0C97E), // warm gold
    ];

    return List.generate(count, (i) {
      return _Particle(
        x: rng.nextDouble(),
        startY: -rng.nextDouble() * 0.5,
        speed: 0.06 + rng.nextDouble() * 0.08,
        drift: (rng.nextDouble() - 0.5) * 0.015,
        rotation: rng.nextDouble() * pi * 2,
        rotSpeed: (rng.nextDouble() - 0.5) * 4,
        width: 5 + rng.nextDouble() * 7,
        height: 3 + rng.nextDouble() * 4,
        color: colors[rng.nextInt(colors.length)],
        isCircle: rng.nextDouble() < 0.2,
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

      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.width / 2, paint);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: p.width, height: p.height),
            const Radius.circular(1),
          ),
          paint,
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.animValue != animValue;
}

// ── Confetti Widget ───────────────────────────────────────────────────────────

class BirthdayConfetti extends StatefulWidget {
  const BirthdayConfetti({super.key});

  @override
  State<BirthdayConfetti> createState() => _BirthdayConfettiState();
}

class _BirthdayConfettiState extends State<BirthdayConfetti>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final _particles = _Particle.generate(70);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
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
    );
  }
}

// ── Birthday Banner ───────────────────────────────────────────────────────────

class BirthdayBanner extends StatefulWidget {
  const BirthdayBanner({super.key});

  @override
  State<BirthdayBanner> createState() => _BirthdayBannerState();
}

class _BirthdayBannerState extends State<BirthdayBanner> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();

    return Container(
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
              '🎂  Happy Birthday, Jyotishacharya Pt. Sandeep Vats Ji  ✦  Birthday Special: 20% off all consultations today!',
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
            onTap: () => setState(() => _dismissed = true),
            child: const Icon(Icons.close, size: 14, color: AppColors.goldMuted),
          ),
        ],
      ),
    );
  }
}
