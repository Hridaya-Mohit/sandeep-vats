import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'starfield_painter.dart';

class HeroSection extends ConsumerStatefulWidget {
  const HeroSection({super.key});

  @override
  ConsumerState<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends ConsumerState<HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _starController;
  final List<StarParticle> _stars = StarParticle.generate(180);

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
  }

  @override
  void dispose() {
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ref.watch(localizationsProvider);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1024;

    return SizedBox(
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Starfield
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _starController,
              builder: (context, child) => CustomPaint(
                painter: StarfieldPainter(
                  stars: _stars,
                  animationValue: _starController.value,
                ),
              ),
            ),
          ),

          // ── Bottom gradient — fades hero into next section
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    AppColors.background.withValues(alpha: 0.5),
                    AppColors.background,
                  ],
                  stops: const [0.0, 0.55, 0.82, 1.0],
                ),
              ),
            ),
          ),

          // ── Content (non-Positioned → defines Stack height)
          isDesktop
              ? _DesktopLayout(l10n: l10n, viewportHeight: size.height)
              : Padding(
                  padding: const EdgeInsets.only(top: 72),
                  child: _MobileLayout(l10n: l10n),
                ),
        ],
      ),
    );
  }
}

// ── Desktop Layout ────────────────────────────────────────────────────────────

class _DesktopLayout extends StatelessWidget {
  final AppLocalizations l10n;
  final double viewportHeight;

  const _DesktopLayout({required this.l10n, required this.viewportHeight});

  @override
  Widget build(BuildContext context) {
    final heroHeight = viewportHeight - 72;
    return SizedBox(
      height: heroHeight + 72, // include navbar offset area
      child: Padding(
        padding: const EdgeInsets.only(top: 72),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left: text content
            Expanded(
              flex: 55,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(80, 40, 48, 40),
                  child: _TextContent(l10n: l10n),
                ),
              ),
            ),
            // Right: full-height photo with zodiac wheel
            Expanded(
              flex: 45,
              child: _HeroPhotoPanel(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Mobile Layout ─────────────────────────────────────────────────────────────

class _MobileLayout extends StatelessWidget {
  final AppLocalizations l10n;
  const _MobileLayout({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 60),
      child: Column(
        children: [
          // Photo panel at fixed height
          SizedBox(
            height: 280,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/sandeep_photo.jpeg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 280,
                  ),
                ),
                // Left fade
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          AppColors.background.withValues(alpha: 0.6),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.3],
                      ),
                    ),
                  ),
                ),
                // Zodiac wheel at bottom-right
                Positioned(
                  bottom: -50,
                  right: -20,
                  child: SizedBox(
                    width: 130,
                    height: 130,
                    child: CustomPaint(painter: _ZodiacWheelPainter()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 64),
          _TextContent(l10n: l10n, centerAligned: true),
        ],
      ),
    );
  }
}

// ── Hero Photo Panel (desktop) ────────────────────────────────────────────────

class _HeroPhotoPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        // Full-height photo — full width crop showing all 3 people
        Image.asset(
          'assets/images/sandeep_photo.jpeg',
          fit: BoxFit.cover,
          alignment: const Alignment(-0.2, 0.0),
        ),

        // Left-to-transparent gradient to blend with background
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.background,
                  AppColors.background.withValues(alpha: 0.55),
                  AppColors.background.withValues(alpha: 0.0),
                ],
                stops: const [0.0, 0.12, 0.38],
              ),
            ),
          ),
        ),

        // Top-to-transparent gradient (blends with navbar area)
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background.withValues(alpha: 0.7),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.18],
              ),
            ),
          ),
        ),

        // Zodiac wheel at bottom-right of photo panel
        Positioned(
          bottom: 24,
          right: 24,
          child: SizedBox(
            width: 200,
            height: 200,
            child: CustomPaint(painter: _ZodiacWheelPainter()),
          ),
        ),
      ],
    );
  }
}

// ── Text Content ──────────────────────────────────────────────────────────────

class _TextContent extends StatelessWidget {
  final AppLocalizations l10n;
  final bool centerAligned;

  const _TextContent({required this.l10n, this.centerAligned = false});

  CrossAxisAlignment get _cross =>
      centerAligned ? CrossAxisAlignment.center : CrossAxisAlignment.start;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: _cross,
      children: [
        Text(l10n.heroLabel, style: AppTextStyles.cinzel(fontSize: 11, letterSpacing: 4))
            .animate()
            .fadeIn(duration: 700.ms),

        const SizedBox(height: 18),

        Text(
          l10n.heroName,
          style: AppTextStyles.cormorant(fontSize: 80, weight: FontWeight.w300, height: 0.95),
        )
            .animate(delay: 150.ms)
            .fadeIn(duration: 700.ms)
            .slideY(begin: 0.08, end: 0, curve: Curves.easeOut),

        const SizedBox(height: 6),

        Text(
          l10n.heroNameAlt,
          style: AppTextStyles.devanagari(
            fontSize: 26,
            color: AppColors.gold.withValues(alpha: 0.65),
          ),
        ).animate(delay: 250.ms).fadeIn(duration: 600.ms),

        const SizedBox(height: 20),

        Container(width: 72, height: 1, color: AppColors.gold)
            .animate(delay: 320.ms)
            .fadeIn(duration: 400.ms)
            .slideX(begin: -0.5, end: 0, curve: Curves.easeOut),

        const SizedBox(height: 20),

        Text(
          l10n.heroTagline,
          textAlign: centerAligned ? TextAlign.center : TextAlign.left,
          style: AppTextStyles.cormorant(
            fontSize: 22,
            color: AppColors.textMuted,
            style: FontStyle.italic,
            height: 1.55,
          ),
        ).animate(delay: 380.ms).fadeIn(duration: 600.ms),

        const SizedBox(height: 8),

        Text(
          l10n.heroTaglineAlt,
          textAlign: centerAligned ? TextAlign.center : TextAlign.left,
          style: AppTextStyles.devanagari(
            fontSize: 13,
            color: AppColors.textSubtle,
            height: 1.7,
          ),
        ).animate(delay: 430.ms).fadeIn(duration: 600.ms),

        const SizedBox(height: 32),

        Wrap(
          spacing: 16,
          runSpacing: 12,
          alignment: centerAligned ? WrapAlignment.center : WrapAlignment.start,
          children: [
            _PrimaryButton(label: l10n.heroCtaPrimary),
            _SecondaryButton(label: l10n.heroCtaSecondary),
          ],
        )
            .animate(delay: 530.ms)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.1, end: 0, curve: Curves.easeOut),

        const SizedBox(height: 32),

        _StatsRow(l10n: l10n).animate(delay: 680.ms).fadeIn(duration: 600.ms),
      ],
    );
  }
}

// ── Buttons ───────────────────────────────────────────────────────────────────

class _PrimaryButton extends StatefulWidget {
  final String label;
  const _PrimaryButton({required this.label});

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/contact'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.goldGlow : AppColors.gold,
            borderRadius: BorderRadius.circular(4),
            boxShadow: _hovered
                ? [BoxShadow(color: AppColors.gold.withValues(alpha: 0.45), blurRadius: 24, spreadRadius: 2)]
                : null,
          ),
          child: Text(
            widget.label,
            style: AppTextStyles.cinzel(fontSize: 11, color: AppColors.background, letterSpacing: 2),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatefulWidget {
  final String label;
  const _SecondaryButton({required this.label});

  @override
  State<_SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<_SecondaryButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/services'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.gold.withValues(alpha: 0.08) : Colors.transparent,
            border: Border.all(
              color: _hovered ? AppColors.gold : AppColors.goldMuted,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            widget.label,
            style: AppTextStyles.cinzel(
              fontSize: 11,
              color: _hovered ? AppColors.gold : AppColors.textMuted,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Stats Row ─────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final AppLocalizations l10n;
  const _StatsRow({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StatItem(value: l10n.statYears,   label: l10n.statYearsLabel),
          _StatDivider(),
          _StatItem(value: l10n.statClients, label: l10n.statClientsLabel),
          _StatDivider(),
          _StatItem(value: l10n.statCities,  label: l10n.statCitiesLabel),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppTextStyles.cormorant(fontSize: 38, color: AppColors.gold, weight: FontWeight.w500)),
          Text(label,  style: AppTextStyles.inter(fontSize: 11, color: AppColors.textSubtle, letterSpacing: 0.5)),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, margin: const EdgeInsets.symmetric(vertical: 6), color: AppColors.borderGold);
  }
}

// ── Zodiac Wheel Painter ──────────────────────────────────────────────────────

class _ZodiacWheelPainter extends CustomPainter {
  static const _signs = ['♈', '♉', '♊', '♋', '♌', '♍', '♎', '♏', '♐', '♑', '♒', '♓'];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = min(size.width, size.height) / 2;

    // Background fill
    final bgPaint = Paint()
      ..color = const Color(0xFF0D0D16).withValues(alpha: 0.95)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, r - 1, bgPaint);

    // Outer halo ring
    canvas.drawCircle(center, r - 1, Paint()
      ..color = AppColors.gold.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6);

    // Outer border
    canvas.drawCircle(center, r - 4, Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5);

    // Symbol ring outer edge
    final symbolOuterR = r * 0.78;
    canvas.drawCircle(center, symbolOuterR, Paint()
      ..color = AppColors.gold.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0);

    // Symbol ring inner edge / center disc border
    final symbolInnerR = r * 0.50;
    canvas.drawCircle(center, symbolInnerR, Paint()
      ..color = AppColors.gold.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0);

    // Center disc fill
    canvas.drawCircle(center, symbolInnerR - 1, Paint()
      ..color = AppColors.gold.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill);

    // 12 sector dividers (outer ring to symbol outer edge)
    final sectorPaint = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    for (int i = 0; i < 12; i++) {
      final angle = (i * 30 - 90) * (pi / 180);
      final x1 = center.dx + symbolInnerR * cos(angle);
      final y1 = center.dy + symbolInnerR * sin(angle);
      final x2 = center.dx + (r - 4) * cos(angle);
      final y2 = center.dy + (r - 4) * sin(angle);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), sectorPaint);
    }

    // Dot marks at 12 positions on outer ring
    final dotPaint = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30 - 90) * (pi / 180);
      final x = center.dx + (r - 4) * cos(angle);
      final y = center.dy + (r - 4) * sin(angle);
      canvas.drawCircle(Offset(x, y), i % 3 == 0 ? 3.5 : 2.0, dotPaint);
    }

    // Zodiac symbols in each sector
    final symbolR = (symbolOuterR + symbolInnerR) / 2;
    for (int i = 0; i < 12; i++) {
      final angle = ((i * 30 + 15) - 90) * (pi / 180);
      final x = center.dx + symbolR * cos(angle);
      final y = center.dy + symbolR * sin(angle);

      final tp = TextPainter(
        text: TextSpan(
          text: _signs[i],
          style: TextStyle(
            fontSize: r * 0.18,
            color: AppColors.gold,
            height: 1.0,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      canvas.save();
      canvas.translate(x, y);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }

    // Sun symbol in center
    final sunTP = TextPainter(
      text: TextSpan(
        text: '☀',
        style: TextStyle(
          fontSize: r * 0.30,
          color: AppColors.gold,
          height: 1.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    sunTP.paint(canvas, Offset(center.dx - sunTP.width / 2, center.dy - sunTP.height / 2));

    // Decorative inner ring around sun
    canvas.drawCircle(center, r * 0.28, Paint()
      ..color = AppColors.gold.withValues(alpha: 0.30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8);

    // Small dots between sectors on symbol inner ring
    for (int i = 0; i < 12; i++) {
      final angle = ((i * 30 + 15) - 90) * (pi / 180);
      final x = center.dx + symbolInnerR * cos(angle);
      final y = center.dy + symbolInnerR * sin(angle);
      canvas.drawCircle(Offset(x, y), 1.5, Paint()
        ..color = AppColors.gold.withValues(alpha: 0.6)
        ..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(_ZodiacWheelPainter old) => false;
}
