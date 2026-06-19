import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/footer.dart';
import '../../core/widgets/nav_bar.dart';
import '../../data/content/services_data.dart';
import '../../data/content/testimonials_data.dart';
import '../../data/models/service_model.dart';
import '../../data/models/testimonial_model.dart';
import '../hero/hero_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = _scrollController.offset > 40;
    if (scrolled != _isScrolled) setState(() => _isScrolled = scrolled);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: const Column(
              children: [
                HeroSection(),
                _AboutTeaser(),
                _ServicesPreview(),
                _TestimonialsPreview(),
                _CTABanner(),
                Footer(),
              ],
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0,
            child: NavBar(isScrolled: _isScrolled),
          ),
        ],
      ),
    );
  }
}

// ── Shared Section Heading ────────────────────────────────────────────────────

class _SectionHeading extends StatelessWidget {
  final String label;
  final String title;
  final String? subtitle;
  final CrossAxisAlignment alignment;

  const _SectionHeading({
    required this.label,
    required this.title,
    this.subtitle,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Row(
          mainAxisSize: alignment == CrossAxisAlignment.center ? MainAxisSize.min : MainAxisSize.max,
          mainAxisAlignment: alignment == CrossAxisAlignment.center ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Container(width: 20, height: 1, color: AppColors.gold),
            const SizedBox(width: 10),
            Text(label, style: AppTextStyles.cinzel(fontSize: 10, letterSpacing: 3.5)),
            const SizedBox(width: 10),
            Container(width: 20, height: 1, color: AppColors.gold),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          title,
          style: AppTextStyles.cormorant(fontSize: 52, weight: FontWeight.w300),
          textAlign: alignment == CrossAxisAlignment.center ? TextAlign.center : TextAlign.left,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 10),
          Text(
            subtitle!,
            style: AppTextStyles.inter(fontSize: 15, color: AppColors.textMuted, height: 1.7),
            textAlign: alignment == CrossAxisAlignment.center ? TextAlign.center : TextAlign.left,
          ),
        ],
      ],
    );
  }
}

// ── About Teaser ─────────────────────────────────────────────────────────────

class _AboutTeaser extends StatelessWidget {
  const _AboutTeaser();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return Container(
      width: double.infinity,
      color: AppColors.surface,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 80 : 24,
              vertical: isDesktop ? 96 : 64,
            ),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 55, child: _AboutText()),
                      const SizedBox(width: 80),
                      Expanded(flex: 45, child: _AboutVisual()),
                    ],
                  )
                : Column(
                    children: [
                      _AboutVisual(),
                      const SizedBox(height: 48),
                      _AboutText(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _AboutText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          label: 'MY STORY',
          title: 'Ancient Wisdom,\nModern Guidance',
        ),
        const SizedBox(height: 28),
        Text(
          'With over 15 years of dedicated practice, I have guided more than 10,000 souls across India and abroad. My journey began in Varanasi, where I studied under Pandit Rameshwar Sharma — a lineage holder of the Parashara tradition.',
          style: AppTextStyles.inter(fontSize: 15, color: AppColors.textMuted, height: 1.8),
        ),
        const SizedBox(height: 16),
        Text(
          'Holding a Jyotish Acharya from Bhartiya Vidya Parishad and a postgraduate degree in Sanskrit, I combine classical Vedic methodology with deep psychological insight to deliver readings that are both precise and compassionate.',
          style: AppTextStyles.inter(fontSize: 15, color: AppColors.textMuted, height: 1.8),
        ),
        const SizedBox(height: 32),
        _QuotePill(
          text: '"I do not predict fear — I illuminate possibility."',
        ),
        const SizedBox(height: 36),
        _OutlineButton(
          label: 'READ MY FULL STORY',
          onTap: () => context.go('/about'),
        ),
      ],
    );
  }
}

class _QuotePill extends StatelessWidget {
  final String text;
  const _QuotePill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: const Border(left: BorderSide(color: AppColors.gold, width: 2)),
        color: AppColors.gold.withValues(alpha: 0.06),
      ),
      child: Text(
        text,
        style: AppTextStyles.cormorant(fontSize: 20, style: FontStyle.italic, color: AppColors.textPrimary, height: 1.5),
      ),
    );
  }
}

class _AboutVisual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Credential cards stacked
          _CredentialCard(
            icon: Icons.school_outlined,
            title: 'Jyotish Acharya',
            subtitle: 'Bhartiya Vidya Parishad',
          ),
          const SizedBox(height: 16),
          _CredentialCard(
            icon: Icons.military_tech_outlined,
            title: 'Vastu Visharad',
            subtitle: 'All India Federation of Astrologers',
          ),
          const SizedBox(height: 16),
          _CredentialCard(
            icon: Icons.language_outlined,
            title: 'Sanskrit Postgraduate',
            subtitle: 'Sampurnanand Sanskrit University',
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _MiniStat(value: '15+', label: 'Years'),
              Container(width: 1, height: 40, color: AppColors.borderGold, margin: const EdgeInsets.symmetric(horizontal: 28)),
              _MiniStat(value: '10K+', label: 'Clients'),
              Container(width: 1, height: 40, color: AppColors.borderGold, margin: const EdgeInsets.symmetric(horizontal: 28)),
              _MiniStat(value: '50+', label: 'Cities'),
            ],
          ),
        ],
      ),
    );
  }
}

class _CredentialCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _CredentialCard({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.borderGold, width: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.gold, size: 20),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.inter(fontSize: 13, color: AppColors.textPrimary, weight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(subtitle, style: AppTextStyles.inter(fontSize: 12, color: AppColors.textSubtle)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  const _MiniStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.cormorant(fontSize: 32, color: AppColors.gold, weight: FontWeight.w500)),
        Text(label, style: AppTextStyles.inter(fontSize: 11, color: AppColors.textSubtle, letterSpacing: 0.5)),
      ],
    );
  }
}

// ── Services Preview ──────────────────────────────────────────────────────────

class _ServicesPreview extends StatelessWidget {
  const _ServicesPreview();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    final preview = kServices.take(4).toList();

    return Container(
      width: double.infinity,
      color: AppColors.background,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 80 : 24,
              vertical: isDesktop ? 96 : 64,
            ),
            child: Column(
              children: [
                const _SectionHeading(
                  label: 'WHAT I OFFER',
                  title: 'Astrological Services',
                  subtitle: 'Each consultation is a private, in-depth session — never a generic reading.',
                  alignment: CrossAxisAlignment.center,
                ),
                const SizedBox(height: 56),
                isDesktop
                    ? Row(
                        children: preview.map((s) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: _ServiceCard(service: s),
                          ),
                        )).toList(),
                      )
                    : Column(
                        children: preview.map((s) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _ServiceCard(service: s),
                        )).toList(),
                      ),
                const SizedBox(height: 48),
                _GoldButton(
                  label: 'VIEW ALL 8 SERVICES',
                  onTap: () => context.go('/services'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final ServiceModel service;
  const _ServiceCard({required this.service});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go('/services'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 260,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.surfaceLight : AppColors.surface,
            border: Border.all(
              color: _hovered ? AppColors.gold : AppColors.borderGold,
              width: _hovered ? 1 : 0.5,
            ),
            borderRadius: BorderRadius.circular(4),
            boxShadow: _hovered
                ? [BoxShadow(color: AppColors.gold.withValues(alpha: 0.08), blurRadius: 30)]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.service.symbol,
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 22,
                      fontFamily: 'serif',
                    ),
                  ),
                  const Spacer(),
                  Icon(widget.service.icon, color: AppColors.gold.withValues(alpha: 0.4), size: 18),
                ],
              ),
              const SizedBox(height: 20),
              Text(widget.service.title, style: AppTextStyles.cormorant(fontSize: 26, weight: FontWeight.w500, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Text(
                widget.service.shortDesc,
                style: AppTextStyles.inter(fontSize: 13, color: AppColors.textSubtle, height: 1.6),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Text(widget.service.price, style: AppTextStyles.cormorant(fontSize: 18, color: AppColors.gold)),
                  const SizedBox(width: 8),
                  Text('· ${widget.service.duration}', style: AppTextStyles.inter(fontSize: 12, color: AppColors.textSubtle)),
                  const Spacer(),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _hovered ? 20 : 0,
                    child: Icon(Icons.arrow_forward, color: AppColors.gold, size: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Testimonials Preview ──────────────────────────────────────────────────────

class _TestimonialsPreview extends StatelessWidget {
  const _TestimonialsPreview();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    final preview = kTestimonials.take(3).toList();

    return Container(
      width: double.infinity,
      color: AppColors.surface,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 80 : 24,
              vertical: isDesktop ? 96 : 64,
            ),
            child: Column(
              children: [
                const _SectionHeading(
                  label: 'CLIENT STORIES',
                  title: 'What They Say',
                  subtitle: 'Real experiences from clients across India and beyond.',
                  alignment: CrossAxisAlignment.center,
                ),
                const SizedBox(height: 56),
                isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: preview.map((t) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: _TestimonialCard(testimonial: t),
                          ),
                        )).toList(),
                      )
                    : Column(
                        children: preview.map((t) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _TestimonialCard(testimonial: t),
                        )).toList(),
                      ),
                const SizedBox(height: 48),
                _OutlineButton(
                  label: 'READ ALL TESTIMONIALS',
                  onTap: () => context.go('/testimonials'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final TestimonialModel testimonial;
  const _TestimonialCard({required this.testimonial});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.borderGold, width: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stars
          Row(
            children: List.generate(5, (i) => Padding(
              padding: const EdgeInsets.only(right: 3),
              child: Icon(Icons.star, size: 13, color: AppColors.gold),
            )),
          ),
          const SizedBox(height: 16),
          // Quote
          Text(
            '"${testimonial.quote.length > 200 ? '${testimonial.quote.substring(0, 200)}…' : testimonial.quote}"',
            style: AppTextStyles.cormorant(fontSize: 17, style: FontStyle.italic, color: AppColors.textMuted, height: 1.65),
          ),
          const SizedBox(height: 24),
          // Author
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceLight,
                  border: Border.fromBorderSide(BorderSide(color: AppColors.borderGold, width: 1)),
                ),
                child: Center(
                  child: Text(testimonial.initials, style: AppTextStyles.cinzel(fontSize: 10, letterSpacing: 1)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(testimonial.name, style: AppTextStyles.inter(fontSize: 13, color: AppColors.textPrimary, weight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                    Text(testimonial.city, style: AppTextStyles.inter(fontSize: 11, color: AppColors.textSubtle)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── CTA Banner ────────────────────────────────────────────────────────────────

class _CTABanner extends StatelessWidget {
  const _CTABanner();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.background,
            const Color(0xFF1A1208),
            AppColors.background,
          ],
        ),
        border: const Border.symmetric(
          horizontal: BorderSide(color: AppColors.borderGold, width: 0.5),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 80 : 24,
              vertical: isDesktop ? 96 : 64,
            ),
            child: Column(
              children: [
                const Text('✦', style: TextStyle(color: AppColors.gold, fontSize: 24)),
                const SizedBox(height: 24),
                Text(
                  'Ready to Illuminate\nYour Path?',
                  style: AppTextStyles.cormorant(fontSize: isDesktop ? 60 : 44, weight: FontWeight.w300, height: 1.15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Every chart holds the answers you seek.\nLet us read yours together.',
                  style: AppTextStyles.inter(fontSize: 15, color: AppColors.textSubtle, height: 1.7),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _GoldButton(
                      label: 'BOOK A CONSULTATION',
                      onTap: () => context.go('/contact'),
                    ),
                    _OutlineButton(
                      label: 'EXPLORE SERVICES',
                      onTap: () => context.go('/services'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Shared Buttons ────────────────────────────────────────────────────────────

class _GoldButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _GoldButton({required this.label, required this.onTap});

  @override
  State<_GoldButton> createState() => _GoldButtonState();
}

class _GoldButtonState extends State<_GoldButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.goldGlow : AppColors.gold,
            borderRadius: BorderRadius.circular(4),
            boxShadow: _hovered
                ? [BoxShadow(color: AppColors.gold.withValues(alpha: 0.4), blurRadius: 24, spreadRadius: 2)]
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

class _OutlineButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _OutlineButton({required this.label, required this.onTap});

  @override
  State<_OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<_OutlineButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.gold.withValues(alpha: 0.08) : Colors.transparent,
            border: Border.all(color: _hovered ? AppColors.gold : AppColors.goldMuted, width: 1),
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
