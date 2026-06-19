import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/page_shell.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(localizationsProvider);
    return PageShell(child: _AboutContent(l10n: l10n));
  }
}

class _AboutContent extends StatelessWidget {
  final AppLocalizations l10n;
  const _AboutContent({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PageBanner(l10n: l10n),
        _BiographySection(l10n: l10n),
        _PhilosophySection(l10n: l10n),
        _CredentialsTimeline(l10n: l10n),
        _StatsSection(),
        _CTASection(l10n: l10n),
      ],
    );
  }
}

// ── Page Banner ───────────────────────────────────────────────────────────────

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
              Text(l10n.aboutBannerLabel, style: AppTextStyles.cinzel(fontSize: 10, letterSpacing: 4)),
              const SizedBox(width: 12),
              Container(width: 24, height: 1, color: AppColors.gold),
            ],
          ),
          const SizedBox(height: 20),
          Text(l10n.aboutBannerTitle, style: AppTextStyles.cormorant(fontSize: 64, weight: FontWeight.w300))
              .animate()
              .fadeIn(duration: 700.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
          const SizedBox(height: 12),
          Text(
            l10n.aboutBannerSubtitle,
            style: AppTextStyles.inter(fontSize: 14, color: AppColors.gold.withValues(alpha: 0.8), letterSpacing: 0.5),
          ).animate(delay: 200.ms).fadeIn(duration: 600.ms),
        ],
      ),
    );
  }
}

// ── Biography ─────────────────────────────────────────────────────────────────

class _BiographySection extends StatelessWidget {
  final AppLocalizations l10n;
  const _BiographySection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

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
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 45, child: _PhotoPlaceholder()),
                      const SizedBox(width: 80),
                      Expanded(flex: 55, child: _BioText(l10n: l10n)),
                    ],
                  )
                : Column(children: [_BioText(l10n: l10n)]),
          ),
        ),
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderGold, width: 0.5),
        borderRadius: BorderRadius.circular(4),
        image: const DecorationImage(
          image: AssetImage('assets/images/sandeep_photo.jpeg'),
          fit: BoxFit.cover,
          alignment: Alignment(0.3, -0.3),
        ),
      ),
    );
  }
}

class _BioText extends StatelessWidget {
  final AppLocalizations l10n;
  const _BioText({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.aboutMyJourney, style: AppTextStyles.cinzel(fontSize: 10, letterSpacing: 3.5)),
        const SizedBox(height: 4),
        Container(width: 32, height: 1, color: AppColors.gold),
        const SizedBox(height: 20),
        Text(
          'Born into a family that revered the Vedic sciences, I was drawn to astrology as a child — watching my grandfather cast charts by hand in the lamplight of our ancestral home in Mathura.',
          style: AppTextStyles.cormorant(fontSize: 22, style: FontStyle.italic, color: AppColors.textPrimary, height: 1.55),
        ),
        const SizedBox(height: 24),
        Text(
          'At seventeen I left for Varanasi, where I spent six years studying under the revered Pandit Rameshwar Sharma — a direct lineage holder of the Brihat Parashara Hora Shastra tradition. Those years were transformative. I learned not just the mathematics of planetary calculation, but the art of compassionate interpretation.',
          style: AppTextStyles.inter(fontSize: 15, color: AppColors.textMuted, height: 1.85),
        ),
        const SizedBox(height: 16),
        Text(
          'I went on to complete my B.Ed. Acharya and then pursued M.A. Jyotish from Delhi University. Currently a Ph.D. Researcher in Vedic astrology, my academic foundation gives intuitive readings a framework grounded in classical texts — from Parashara and Jaimini to Nadi Grantha.',
          style: AppTextStyles.inter(fontSize: 15, color: AppColors.textMuted, height: 1.85),
        ),
        const SizedBox(height: 16),
        Text(
          'Since 2009, I have given private consultations to over 10,000 clients across 50+ cities — from village farmers navigating inheritance disputes to CEOs charting corporate strategy. Every chart has been a window into a unique soul.',
          style: AppTextStyles.inter(fontSize: 15, color: AppColors.textMuted, height: 1.85),
        ),
        const SizedBox(height: 32),
        const _QuoteBox(
          text: '"Astrology does not compel. It reveals the energies at play so you can navigate them with wisdom and free will."',
        ),
      ],
    );
  }
}

class _QuoteBox extends StatelessWidget {
  final String text;
  const _QuoteBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: const Border(left: BorderSide(color: AppColors.gold, width: 2)),
        color: AppColors.gold.withValues(alpha: 0.05),
      ),
      child: Text(
        text,
        style: AppTextStyles.cormorant(fontSize: 20, style: FontStyle.italic, color: AppColors.textPrimary, height: 1.6),
      ),
    );
  }
}

// ── Philosophy ────────────────────────────────────────────────────────────────

class _PhilosophySection extends StatelessWidget {
  final AppLocalizations l10n;
  const _PhilosophySection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surface,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
            child: Column(
              children: [
                const Text('✦', style: TextStyle(color: AppColors.gold, fontSize: 20)),
                const SizedBox(height: 24),
                Text(
                  '"I do not predict fear —\nI illuminate possibility."',
                  style: AppTextStyles.cormorant(fontSize: 40, weight: FontWeight.w300, height: 1.35),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(width: 48, height: 1, color: AppColors.borderGold),
                const SizedBox(height: 16),
                Text('— Sandeep Vats', style: AppTextStyles.cinzel(fontSize: 11, letterSpacing: 3, color: AppColors.gold)),
                const SizedBox(height: 40),
                Text(
                  'My approach to astrology is rooted in empowerment, not fatalism. The stars reveal patterns — but you hold the choices. My role is to help you understand those patterns clearly so you can act with confidence, timing, and clarity.',
                  style: AppTextStyles.inter(fontSize: 15, color: AppColors.textMuted, height: 1.8),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Credentials Timeline ──────────────────────────────────────────────────────

class _CredentialsTimeline extends StatelessWidget {
  final AppLocalizations l10n;
  const _CredentialsTimeline({required this.l10n});

  static final _entries = [
    (year: '2004', title: 'Moved to Varanasi', body: 'Began formal studies in Vedic Jyotisha under Pandit Rameshwar Sharma of the Parashara tradition.'),
    (year: '2009', title: 'B.Ed. Acharya', body: 'Completed the B.Ed. Acharya programme, strengthening the pedagogical and interpretive foundation of Vedic Jyotisha.'),
    (year: '2011', title: 'M.A. Jyotish — Delhi University', body: 'Awarded the M.A. in Jyotish from Delhi University (D.U.) — a rigorous academic grounding in classical Vedic astrology and allied sciences.'),
    (year: '2012', title: 'Private Practice Begins', body: 'Opened the Mata Bhimeshwari Devi Jyotish Kendra in Rohini, Delhi. Initial focus: Kundli analysis, Kundli Milan, and Vastu Shastra for families across NCR.'),
    (year: '2018', title: '5,000 Clients Milestone', body: 'Expanded practice nationally; began online consultations reaching clients across the Gulf, UK, and North America.'),
    (year: '2022', title: 'Ph.D. Researcher', body: 'Pursuing doctoral research on classical predictive techniques of Vedic Jyotisha, further deepening the academic rigor behind every consultation.'),
    (year: '2024', title: '10,000 Lives Guided', body: 'Surpassed 10,000 individual consultations with a 97% satisfaction rate, as reported in follow-up surveys.'),
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
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 24, vertical: isDesktop ? 96 : 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 24, height: 1, color: AppColors.gold),
                    const SizedBox(width: 12),
                    Text(l10n.aboutMilestonesLabel, style: AppTextStyles.cinzel(fontSize: 10, letterSpacing: 3.5)),
                    const SizedBox(width: 12),
                    Container(width: 24, height: 1, color: AppColors.gold),
                  ],
                ),
                const SizedBox(height: 16),
                Text(l10n.aboutMilestonesTitle, style: AppTextStyles.cormorant(fontSize: 48, weight: FontWeight.w300)),
                const SizedBox(height: 56),
                ..._entries.map((e) => _TimelineEntry(year: e.year, title: e.title, body: e.body)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  final String year;
  final String title;
  final String body;

  const _TimelineEntry({required this.year, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 700;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: isDesktop ? 80 : 56,
            child: Text(year, style: AppTextStyles.cormorant(fontSize: 18, color: AppColors.gold, weight: FontWeight.w500)),
          ),
          Column(
            children: [
              Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.gold)),
              Expanded(child: Container(width: 1, color: AppColors.borderGold)),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.inter(fontSize: 15, color: AppColors.textPrimary, weight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(body, style: AppTextStyles.inter(fontSize: 14, color: AppColors.textMuted, height: 1.7)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stats ─────────────────────────────────────────────────────────────────────

class _StatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Center(
        child: Wrap(
          spacing: 0,
          runSpacing: 32,
          alignment: WrapAlignment.center,
          children: [
            _StatPill(value: '15+', label: 'Years of Practice'),
            _Vbar(),
            _StatPill(value: '10K+', label: 'Clients Guided'),
            _Vbar(),
            _StatPill(value: '50+', label: 'Cities Served'),
            _Vbar(),
            _StatPill(value: '97%', label: 'Satisfaction Rate'),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String value;
  final String label;
  const _StatPill({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Text(value, style: AppTextStyles.cormorant(fontSize: 52, color: AppColors.gold, weight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.inter(fontSize: 12, color: AppColors.textSubtle, letterSpacing: 0.5)),
        ],
      ),
    );
  }
}

class _Vbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 48, color: AppColors.borderGold);
  }
}

// ── CTA ───────────────────────────────────────────────────────────────────────

class _CTASection extends StatelessWidget {
  final AppLocalizations l10n;
  const _CTASection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: Column(
          children: [
            Text(l10n.aboutBeginJourney, style: AppTextStyles.cormorant(fontSize: 48, weight: FontWeight.w300)),
            const SizedBox(height: 12),
            Text(l10n.aboutBeginBody, style: AppTextStyles.inter(fontSize: 15, color: AppColors.textMuted), textAlign: TextAlign.center),
            const SizedBox(height: 36),
            _GoldBtn(label: l10n.ctaBookConsultation, onTap: () => context.go('/contact')),
          ],
        ),
      ),
    );
  }
}

class _GoldBtn extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _GoldBtn({required this.label, required this.onTap});

  @override
  State<_GoldBtn> createState() => _GoldBtnState();
}

class _GoldBtnState extends State<_GoldBtn> {
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
