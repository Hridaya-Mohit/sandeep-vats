import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/page_shell.dart';
import '../../data/content/services_data.dart';
import '../../data/models/service_model.dart';

class ServicesPage extends ConsumerWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(localizationsProvider);
    return PageShell(child: _ServicesContent(l10n: l10n));
  }
}

class _ServicesContent extends StatelessWidget {
  final AppLocalizations l10n;
  const _ServicesContent({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PageBanner(l10n: l10n),
        const _IntroRow(),
        _ServicesGrid(l10n: l10n),
        _ProcessSection(l10n: l10n),
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
              Text(l10n.servicesBannerLabel, style: AppTextStyles.cinzel(fontSize: 10, letterSpacing: 4)),
              const SizedBox(width: 12),
              Container(width: 24, height: 1, color: AppColors.gold),
            ],
          ),
          const SizedBox(height: 20),
          Text(l10n.servicesBannerTitle, style: AppTextStyles.cormorant(fontSize: 64, weight: FontWeight.w300))
              .animate()
              .fadeIn(duration: 700.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
          const SizedBox(height: 12),
          Text(
            l10n.servicesBannerSubtitle,
            style: AppTextStyles.inter(fontSize: 15, color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ).animate(delay: 200.ms).fadeIn(duration: 600.ms),
        ],
      ),
    );
  }
}

// ── Intro Row ─────────────────────────────────────────────────────────────────

class _IntroRow extends StatelessWidget {
  const _IntroRow();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return Container(
      width: double.infinity,
      color: AppColors.background,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 80 : 24,
              vertical: 56,
            ),
            child: isDesktop
                ? Row(
                    children: [
                      Expanded(child: _IntroItem(icon: Icons.person_outline, title: 'Private Sessions', body: 'Every consultation is one-on-one — never templated, never rushed. Your chart receives full, undivided attention.')),
                      const SizedBox(width: 32),
                      Expanded(child: _IntroItem(icon: Icons.translate, title: 'Hindi & English', body: 'Sessions are available in both Hindi and English. Choose the language you are most comfortable expressing yourself in.')),
                      const SizedBox(width: 32),
                      Expanded(child: _IntroItem(icon: Icons.videocam_outlined, title: 'Online & In-Person', body: 'Meet via secure video call from anywhere in the world, or visit the Noida consultation office by prior appointment.')),
                      const SizedBox(width: 32),
                      Expanded(child: _IntroItem(icon: Icons.description_outlined, title: 'Written Reports', body: 'Most sessions include a detailed written report (PDF) sent within 48 hours, so you can revisit the insights anytime.')),
                    ],
                  )
                : Column(
                    children: [
                      _IntroItem(icon: Icons.person_outline, title: 'Private Sessions', body: 'Every consultation is one-on-one — never templated, never rushed.'),
                      const SizedBox(height: 24),
                      _IntroItem(icon: Icons.translate, title: 'Hindi & English', body: 'Sessions available in both Hindi and English.'),
                      const SizedBox(height: 24),
                      _IntroItem(icon: Icons.videocam_outlined, title: 'Online & In-Person', body: 'Meet via video call or at the Noida office.'),
                      const SizedBox(height: 24),
                      _IntroItem(icon: Icons.description_outlined, title: 'Written Reports', body: 'Detailed PDF report delivered within 48 hours.'),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _IntroItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _IntroItem({required this.icon, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.borderGold, width: 1),
          ),
          child: Icon(icon, size: 18, color: AppColors.gold),
        ),
        const SizedBox(height: 16),
        Text(title, style: AppTextStyles.inter(fontSize: 14, color: AppColors.textPrimary, weight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text(body, style: AppTextStyles.inter(fontSize: 13, color: AppColors.textSubtle, height: 1.65)),
      ],
    );
  }
}

// ── Services Grid ─────────────────────────────────────────────────────────────

class _ServicesGrid extends StatelessWidget {
  final AppLocalizations l10n;
  const _ServicesGrid({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cols = width > 1100 ? 3 : (width > 700 ? 2 : 1);

    return Container(
      width: double.infinity,
      color: AppColors.surface,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width > 900 ? 80 : 24,
              vertical: 80,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: width > 1100 ? 0.78 : (width > 700 ? 0.82 : 1.1),
              ),
              itemCount: kServices.length,
              itemBuilder: (context, i) => _ServiceDetailCard(service: kServices[i])
                  .animate(delay: (i * 80).ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.08, end: 0, curve: Curves.easeOut),
            ),
          ),
        ),
      ),
    );
  }
}

class _ServiceDetailCard extends StatefulWidget {
  final ServiceModel service;
  const _ServiceDetailCard({required this.service});

  @override
  State<_ServiceDetailCard> createState() => _ServiceDetailCardState();
}

class _ServiceDetailCardState extends State<_ServiceDetailCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.service;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.surfaceLight : AppColors.background,
          border: Border.all(
            color: _hovered ? AppColors.gold : AppColors.borderGold,
            width: _hovered ? 1 : 0.5,
          ),
          borderRadius: BorderRadius.circular(4),
          boxShadow: _hovered
              ? [BoxShadow(color: AppColors.gold.withValues(alpha: 0.1), blurRadius: 40)]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Symbol + Icon row
            Row(
              children: [
                Text(s.symbol, style: const TextStyle(color: AppColors.gold, fontSize: 26, fontFamily: 'serif')),
                const Spacer(),
                Icon(s.icon, color: AppColors.gold.withValues(alpha: 0.35), size: 18),
              ],
            ),
            const SizedBox(height: 16),
            Text(s.title, style: AppTextStyles.cormorant(fontSize: 28, weight: FontWeight.w500, color: AppColors.textPrimary)),
            Text(s.titleHi, style: AppTextStyles.devanagari(fontSize: 14, color: AppColors.gold.withValues(alpha: 0.6))),
            const SizedBox(height: 12),
            Container(width: 32, height: 0.5, color: AppColors.borderGold),
            const SizedBox(height: 12),
            Text(
              s.description,
              style: AppTextStyles.inter(fontSize: 13, color: AppColors.textMuted, height: 1.7),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            // Includes
            ...s.includes.take(3).map((inc) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.check, size: 12, color: AppColors.gold),
                  const SizedBox(width: 8),
                  Flexible(child: Text(inc, style: AppTextStyles.inter(fontSize: 12, color: AppColors.textSubtle))),
                ],
              ),
            )),
            const SizedBox(height: 16),
            // Footer row
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.price, style: AppTextStyles.cormorant(fontSize: 22, color: AppColors.gold, weight: FontWeight.w500)),
                    Text(s.duration, style: AppTextStyles.inter(fontSize: 11, color: AppColors.textSubtle)),
                  ],
                ),
                const Spacer(),
                _BookBtn(onTap: () => context.go('/contact')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BookBtn extends StatefulWidget {
  final VoidCallback onTap;
  const _BookBtn({required this.onTap});

  @override
  State<_BookBtn> createState() => _BookBtnState();
}

class _BookBtnState extends State<_BookBtn> {
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.gold : Colors.transparent,
            border: Border.all(color: AppColors.gold, width: 1),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            'BOOK',
            style: AppTextStyles.cinzel(
              fontSize: 9,
              color: _hovered ? AppColors.background : AppColors.gold,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}

// ── How It Works ──────────────────────────────────────────────────────────────

class _ProcessSection extends StatelessWidget {
  final AppLocalizations l10n;
  const _ProcessSection({required this.l10n});

  static const _steps = [
    (num: '01', title: 'Book Online', body: 'Choose your consultation type and select a time slot via the contact form or WhatsApp.'),
    (num: '02', title: 'Share Birth Details', body: 'Provide your date, exact time, and place of birth. For Kundli Milan, details of both partners are needed.'),
    (num: '03', title: 'Pre-Session Prep', body: 'Your chart is cast and studied in advance. Sessions begin with a focused introduction — no wasted time.'),
    (num: '04', title: 'Your Session', body: 'A private 45–90 minute deep-dive via video call or in-person in Noida. Come with your questions.'),
    (num: '05', title: 'Written Report', body: 'A comprehensive PDF report summarising insights, predictions, and personalised remedies — delivered within 48 hours.'),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return Container(
      width: double.infinity,
      color: AppColors.background,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 24, vertical: 80),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 24, height: 1, color: AppColors.gold),
                    const SizedBox(width: 12),
                    Text(l10n.servicesProcessLabel, style: AppTextStyles.cinzel(fontSize: 10, letterSpacing: 3.5)),
                    const SizedBox(width: 12),
                    Container(width: 24, height: 1, color: AppColors.gold),
                  ],
                ),
                const SizedBox(height: 16),
                Text(l10n.servicesProcessTitle, style: AppTextStyles.cormorant(fontSize: 48, weight: FontWeight.w300)),
                const SizedBox(height: 56),
                isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _steps.map((s) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: _ProcessStep(num: s.num, title: s.title, body: s.body),
                          ),
                        )).toList(),
                      )
                    : Column(
                        children: _steps.map((s) => Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: _ProcessStep(num: s.num, title: s.title, body: s.body, horizontal: true),
                        )).toList(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProcessStep extends StatelessWidget {
  final String num;
  final String title;
  final String body;
  final bool horizontal;

  const _ProcessStep({required this.num, required this.title, required this.body, this.horizontal = false});

  @override
  Widget build(BuildContext context) {
    if (horizontal) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(num, style: AppTextStyles.cormorant(fontSize: 36, color: AppColors.gold.withValues(alpha: 0.3), weight: FontWeight.w300)),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.inter(fontSize: 14, color: AppColors.textPrimary, weight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(body, style: AppTextStyles.inter(fontSize: 13, color: AppColors.textSubtle, height: 1.65)),
              ],
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(num, style: AppTextStyles.cormorant(fontSize: 48, color: AppColors.gold.withValues(alpha: 0.3), weight: FontWeight.w300)),
        Container(width: 32, height: 1, color: AppColors.borderGold),
        const SizedBox(height: 16),
        Text(title, style: AppTextStyles.inter(fontSize: 14, color: AppColors.textPrimary, weight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text(body, style: AppTextStyles.inter(fontSize: 13, color: AppColors.textSubtle, height: 1.65)),
      ],
    );
  }
}

// ── CTA ───────────────────────────────────────────────────────────────────────

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
            Text(l10n.servicesBookingTitle, style: AppTextStyles.cormorant(fontSize: 48, weight: FontWeight.w300)),
            const SizedBox(height: 12),
            Text(l10n.servicesBookingBody, style: AppTextStyles.inter(fontSize: 15, color: AppColors.textMuted)),
            const SizedBox(height: 36),
            _GoldBtnS(label: l10n.servicesScheduleNow, onTap: () => context.go('/contact')),
          ],
        ),
      ),
    );
  }
}

class _GoldBtnS extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _GoldBtnS({required this.label, required this.onTap});

  @override
  State<_GoldBtnS> createState() => _GoldBtnSState();
}

class _GoldBtnSState extends State<_GoldBtnS> {
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
            boxShadow: _hovered
                ? [BoxShadow(color: AppColors.gold.withValues(alpha: 0.4), blurRadius: 24)]
                : null,
          ),
          child: Text(widget.label, style: AppTextStyles.cinzel(fontSize: 11, color: AppColors.background, letterSpacing: 2)),
        ),
      ),
    );
  }
}
