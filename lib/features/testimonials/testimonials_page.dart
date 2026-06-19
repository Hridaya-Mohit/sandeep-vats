import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/page_shell.dart';
import '../../data/content/testimonials_data.dart';
import '../../data/models/testimonial_model.dart';

class TestimonialsPage extends ConsumerWidget {
  const TestimonialsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(localizationsProvider);
    return PageShell(child: _TestimonialsContent(l10n: l10n));
  }
}

class _TestimonialsContent extends StatelessWidget {
  final AppLocalizations l10n;
  const _TestimonialsContent({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PageBanner(l10n: l10n),
        const _StatsBar(),
        const _TestimonialsGrid(),
        const _FeaturedQuote(),
        _BookingCTA(l10n: l10n),
      ],
    );
  }
}

// ── Banner ────────────────────────────────────────────────────────────────────

class _PageBanner extends StatelessWidget {
  final AppLocalizations l10n;
  const _PageBanner({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.background, AppColors.surface],
        ),
        border: Border(bottom: BorderSide(color: AppColors.borderGold, width: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 24, height: 1, color: AppColors.gold),
              const SizedBox(width: 12),
              Text(l10n.testimonialsBannerLabel, style: AppTextStyles.cinzel(fontSize: 10, letterSpacing: 4)),
              const SizedBox(width: 12),
              Container(width: 24, height: 1, color: AppColors.gold),
            ],
          ),
          const SizedBox(height: 20),
          Text(l10n.testimonialsBannerTitle, style: AppTextStyles.cormorant(fontSize: 64, weight: FontWeight.w300))
              .animate()
              .fadeIn(duration: 700.ms)
              .slideY(begin: 0.1, end: 0),
          const SizedBox(height: 12),
          Text(
            l10n.testimonialsBannerSubtitle,
            style: AppTextStyles.inter(fontSize: 15, color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ).animate(delay: 200.ms).fadeIn(duration: 600.ms),
        ],
      ),
    );
  }
}

// ── Stats Bar ─────────────────────────────────────────────────────────────────

class _StatsBar extends StatelessWidget {
  const _StatsBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Wrap(
          spacing: 0,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          children: [
            _StatBadge(value: '10,000+', label: 'Consultations'),
            _VLine(),
            _StatBadge(value: '97%', label: 'Satisfaction Rate'),
            _VLine(),
            _StatBadge(value: '5.0', label: 'Average Rating'),
            _VLine(),
            _StatBadge(value: '50+', label: 'Cities Reached'),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String value;
  final String label;
  const _StatBadge({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Text(value, style: AppTextStyles.cormorant(fontSize: 44, color: AppColors.gold, weight: FontWeight.w500)),
          Text(label, style: AppTextStyles.inter(fontSize: 12, color: AppColors.textSubtle, letterSpacing: 0.5)),
        ],
      ),
    );
  }
}

class _VLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 48, color: AppColors.borderGold);
  }
}

// ── Testimonials Grid ─────────────────────────────────────────────────────────

class _TestimonialsGrid extends StatelessWidget {
  const _TestimonialsGrid();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    final isTablet = width > 650;

    return Container(
      width: double.infinity,
      color: AppColors.background,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 80 : 24,
              vertical: 80,
            ),
            child: isDesktop
                ? _DesktopLayout()
                : _MobileLayout(isTablet: isTablet),
          ),
        ),
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Three columns, alternating heights for masonry feel
    final col1 = [kTestimonials[0], kTestimonials[3]];
    final col2 = [kTestimonials[1], kTestimonials[4]];
    final col3 = [kTestimonials[2], kTestimonials[5]];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _TColumn(items: col1, delay: 0)),
        const SizedBox(width: 24),
        Expanded(child: _TColumn(items: col2, delay: 100)),
        const SizedBox(width: 24),
        Expanded(child: _TColumn(items: col3, delay: 200)),
      ],
    );
  }
}

class _TColumn extends StatelessWidget {
  final List<TestimonialModel> items;
  final int delay;

  const _TColumn({required this.items, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: items
            .map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _FullTestimonialCard(testimonial: t)
                      .animate(delay: delay.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.06, end: 0),
                ))
            .toList(),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final bool isTablet;
  const _MobileLayout({required this.isTablet});

  @override
  Widget build(BuildContext context) {
    if (isTablet) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [kTestimonials[0], kTestimonials[2], kTestimonials[4]]
                  .map((t) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _FullTestimonialCard(testimonial: t),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Column(
                children: [kTestimonials[1], kTestimonials[3], kTestimonials[5]]
                    .map((t) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _FullTestimonialCard(testimonial: t),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      );
    }
    return Column(
      children: kTestimonials
          .map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _FullTestimonialCard(testimonial: t),
              ))
          .toList(),
    );
  }
}

class _FullTestimonialCard extends StatelessWidget {
  final TestimonialModel testimonial;
  const _FullTestimonialCard({required this.testimonial});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border.all(color: AppColors.borderGold, width: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stars
          Row(
            children: List.generate(
              testimonial.rating,
              (i) => const Padding(
                padding: EdgeInsets.only(right: 3),
                child: Icon(Icons.star, size: 13, color: AppColors.gold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Opening quote mark
          Text('"', style: AppTextStyles.cormorant(fontSize: 52, color: AppColors.gold, height: 0.9)),
          const SizedBox(height: 8),
          // Quote body
          Text(
            testimonial.quote,
            style: AppTextStyles.inter(fontSize: 14, color: AppColors.textMuted, height: 1.75),
          ),
          const SizedBox(height: 24),
          Container(width: double.infinity, height: 0.5, color: AppColors.borderGold),
          const SizedBox(height: 20),
          // Author row
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.borderGold, AppColors.surface],
                  ),
                  border: Border.all(color: AppColors.borderGold, width: 1),
                ),
                child: Center(
                  child: Text(testimonial.initials, style: AppTextStyles.cinzel(fontSize: 10, letterSpacing: 1, color: AppColors.gold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(testimonial.name, style: AppTextStyles.inter(fontSize: 13, color: AppColors.textPrimary, weight: FontWeight.w600)),
                    Text(testimonial.city, style: AppTextStyles.inter(fontSize: 12, color: AppColors.textSubtle)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderGold, width: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  testimonial.service,
                  style: AppTextStyles.inter(fontSize: 10, color: AppColors.gold.withValues(alpha: 0.8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Featured Quote ────────────────────────────────────────────────────────────

class _FeaturedQuote extends StatelessWidget {
  const _FeaturedQuote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
            child: Column(
              children: [
                const Text('✦  ✦  ✦', style: TextStyle(color: AppColors.gold, fontSize: 14, letterSpacing: 8)),
                const SizedBox(height: 32),
                Text(
                  '"Coming to Sandeep ji was one of the best decisions of my life. He does not just read a chart — he reads a person. I felt truly heard for the first time."',
                  style: AppTextStyles.cormorant(fontSize: 26, style: FontStyle.italic, color: AppColors.textPrimary, height: 1.6),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(width: 48, height: 1, color: AppColors.borderGold),
                const SizedBox(height: 16),
                Text('Meenakshi Pillai, Chennai', style: AppTextStyles.inter(fontSize: 13, color: AppColors.textSubtle)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Booking CTA ───────────────────────────────────────────────────────────────

class _BookingCTA extends StatelessWidget {
  final AppLocalizations l10n;
  const _BookingCTA({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: Column(
          children: [
            Text(l10n.testimonialsBookingTitle, style: AppTextStyles.cormorant(fontSize: 48, weight: FontWeight.w300)),
            const SizedBox(height: 12),
            Text(l10n.testimonialsBookingBody, style: AppTextStyles.inter(fontSize: 15, color: AppColors.textMuted), textAlign: TextAlign.center),
            const SizedBox(height: 36),
            _GoldBtnT(label: l10n.ctaBookConsultation, onTap: () => context.go('/contact')),
          ],
        ),
      ),
    );
  }
}

class _GoldBtnT extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _GoldBtnT({required this.label, required this.onTap});

  @override
  State<_GoldBtnT> createState() => _GoldBtnTState();
}

class _GoldBtnTState extends State<_GoldBtnT> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.goldGlow : AppColors.gold,
            borderRadius: BorderRadius.circular(4),
            boxShadow: _hovered ? [BoxShadow(color: AppColors.gold.withValues(alpha: 0.4), blurRadius: 24)] : null,
          ),
          child: Text(widget.label, style: AppTextStyles.cinzel(fontSize: 11, color: AppColors.background, letterSpacing: 2)),
        ),
      ),
    );
  }
}
