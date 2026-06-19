import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/page_shell.dart';

class ContactPage extends ConsumerWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(localizationsProvider);
    return PageShell(child: _ContactContent(l10n: l10n));
  }
}

class _ContactContent extends StatelessWidget {
  final AppLocalizations l10n;
  const _ContactContent({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PageBanner(l10n: l10n),
        _MainSection(l10n: l10n),
        _FAQSection(l10n: l10n),
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
              Text(l10n.contactBannerLabel, style: AppTextStyles.cinzel(fontSize: 10, letterSpacing: 4)),
              const SizedBox(width: 12),
              Container(width: 24, height: 1, color: AppColors.gold),
            ],
          ),
          const SizedBox(height: 20),
          Text(l10n.contactBannerTitle, style: AppTextStyles.cormorant(fontSize: 64, weight: FontWeight.w300))
              .animate()
              .fadeIn(duration: 700.ms)
              .slideY(begin: 0.1, end: 0),
          const SizedBox(height: 12),
          Text(
            l10n.contactBannerSubtitle,
            style: AppTextStyles.inter(fontSize: 15, color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ).animate(delay: 200.ms).fadeIn(duration: 600.ms),
        ],
      ),
    );
  }
}

// ── Main Section ──────────────────────────────────────────────────────────────

class _MainSection extends StatelessWidget {
  final AppLocalizations l10n;
  const _MainSection({required this.l10n});

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
                      Expanded(flex: 55, child: _ContactForm(l10n: l10n)),
                      const SizedBox(width: 80),
                      Expanded(flex: 45, child: const _ContactInfo()),
                    ],
                  )
                : Column(
                    children: [
                      const _ContactInfo(),
                      const SizedBox(height: 56),
                      _ContactForm(l10n: l10n),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// ── Contact Form ──────────────────────────────────────────────────────────────

class _ContactForm extends StatefulWidget {
  final AppLocalizations l10n;
  const _ContactForm({required this.l10n});

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  String _consultationType = 'Kundli Analysis';
  bool _submitted = false;

  static const _types = [
    'Kundli Analysis',
    'Kundli Milan',
    'Vastu Shastra',
    'Numerology',
    'Prashna Kundli',
    'Career & Finance',
    'Gemstone Consultation',
    'Remedial Astrology',
    'Not sure — general query',
  ];

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return _SuccessMessage(l10n: widget.l10n);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.l10n.contactSendMessage, style: AppTextStyles.cinzel(fontSize: 10, letterSpacing: 3.5)),
        const SizedBox(height: 4),
        Container(width: 32, height: 1, color: AppColors.gold),
        const SizedBox(height: 28),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: _Field(label: 'Full Name', hint: 'Your name')),
                  const SizedBox(width: 16),
                  Expanded(child: _Field(label: 'Phone / WhatsApp', hint: '+91 XXXXX XXXXX')),
                ],
              ),
              const SizedBox(height: 20),
              _Field(label: 'Email Address', hint: 'your@email.com'),
              const SizedBox(height: 20),
              _ConsultationTypeDropdown(
                value: _consultationType,
                types: _types,
                onChanged: (v) => setState(() => _consultationType = v!),
              ),
              const SizedBox(height: 20),
              _Field(
                label: 'Date of Birth',
                hint: 'DD/MM/YYYY  ·  HH:MM  ·  Place of Birth',
              ),
              const SizedBox(height: 20),
              _Field(label: 'Message', hint: 'Any specific questions or concerns…', maxLines: 5),
              const SizedBox(height: 32),
              _SubmitButton(
                label: widget.l10n.contactSendRequest,
                onTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    setState(() => _submitted = true);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Field extends StatefulWidget {
  final String label;
  final String hint;
  final int maxLines;

  const _Field({required this.label, required this.hint, this.maxLines = 1});

  @override
  State<_Field> createState() => _FieldState();
}

class _FieldState extends State<_Field> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyles.inter(fontSize: 12, color: AppColors.textSubtle, letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Focus(
          onFocusChange: (f) => setState(() => _focused = f),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              border: Border.all(
                color: _focused ? AppColors.gold : AppColors.borderGold,
                width: _focused ? 1 : 0.5,
              ),
              borderRadius: BorderRadius.circular(3),
            ),
            child: TextFormField(
              maxLines: widget.maxLines,
              style: AppTextStyles.inter(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: AppTextStyles.inter(fontSize: 14, color: AppColors.textSubtle),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ConsultationTypeDropdown extends StatelessWidget {
  final String value;
  final List<String> types;
  final ValueChanged<String?> onChanged;

  const _ConsultationTypeDropdown({
    required this.value,
    required this.types,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Consultation Type', style: AppTextStyles.inter(fontSize: 12, color: AppColors.textSubtle, letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderGold, width: 0.5),
            borderRadius: BorderRadius.circular(3),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            dropdownColor: AppColors.surface,
            underline: const SizedBox(),
            style: AppTextStyles.inter(fontSize: 14, color: AppColors.textPrimary),
            icon: const Icon(Icons.expand_more, color: AppColors.gold, size: 18),
            items: types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _SubmitButton({required this.label, required this.onTap});

  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
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
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.goldGlow : AppColors.gold,
            borderRadius: BorderRadius.circular(4),
            boxShadow: _hovered
                ? [BoxShadow(color: AppColors.gold.withValues(alpha: 0.4), blurRadius: 20)]
                : null,
          ),
          child: Center(
            child: Text(
              widget.label,
              style: AppTextStyles.cinzel(fontSize: 11, color: AppColors.background, letterSpacing: 2.5),
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessMessage extends StatelessWidget {
  final AppLocalizations l10n;
  const _SuccessMessage({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderGold, width: 0.5),
        color: AppColors.gold.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.gold, size: 48),
          const SizedBox(height: 20),
          Text(l10n.contactSuccessTitle, style: AppTextStyles.cormorant(fontSize: 36, weight: FontWeight.w300)),
          const SizedBox(height: 12),
          Text(
            l10n.contactSuccessBody,
            style: AppTextStyles.inter(fontSize: 14, color: AppColors.textMuted, height: 1.7),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.96, 0.96), end: const Offset(1, 1));
  }
}

// ── Contact Info ──────────────────────────────────────────────────────────────

class _ContactInfo extends StatelessWidget {
  const _ContactInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('CONTACT', style: AppTextStyles.cinzel(fontSize: 10, letterSpacing: 3.5)),
        const SizedBox(height: 4),
        Container(width: 32, height: 1, color: AppColors.gold),
        const SizedBox(height: 28),
        _InfoCard(
          icon: Icons.location_on_outlined,
          title: 'Office Address',
          body: 'Mata Bhimeshwari Devi Jyotish Kendra\nPlot No. 76, Pocket-1, Ground Floor\nSector-24, Near D.D.A. Market\nRohini, Delhi',
        ),
        const SizedBox(height: 20),
        _InfoCard(
          icon: Icons.phone_outlined,
          title: 'Phone & WhatsApp',
          body: '+91 98915 86497',
          sub: 'Mon–Sat · 10:00 AM – 7:00 PM IST',
        ),
        const SizedBox(height: 20),
        _InfoCard(
          icon: Icons.mail_outlined,
          title: 'Email',
          body: 'sandeepvats.jyotish@gmail.com',
          sub: 'Responses within 24 hours',
        ),
        const SizedBox(height: 20),
        _InfoCard(
          icon: Icons.camera_alt_outlined,
          title: 'Instagram',
          body: '@astrologer_sandeep_vats19',
          sub: 'Daily astrological insights & updates',
        ),
        const SizedBox(height: 32),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.06),
            border: const Border(left: BorderSide(color: AppColors.gold, width: 2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Session Rates', style: AppTextStyles.cinzel(fontSize: 10, letterSpacing: 3, color: AppColors.gold)),
              const SizedBox(height: 12),
              ...[
                ('Kundli Analysis', '₹2,100 · 90 min'),
                ('Kundli Milan', '₹1,800 · 75 min'),
                ('Vastu Shastra', '₹1,500 · 60 min'),
                ('Numerology', '₹1,100 · 60 min'),
                ('Prashna Kundli', '₹800 · 45 min'),
              ].map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(child: Text(e.$1, style: AppTextStyles.inter(fontSize: 13, color: AppColors.textMuted))),
                        Text(e.$2, style: AppTextStyles.inter(fontSize: 13, color: AppColors.textSubtle)),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final String? sub;

  const _InfoCard({required this.icon, required this.title, required this.body, this.sub});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.borderGold, width: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderGold, width: 1),
            ),
            child: Icon(icon, size: 16, color: AppColors.gold),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.inter(fontSize: 12, color: AppColors.textSubtle, letterSpacing: 0.3)),
                const SizedBox(height: 4),
                Text(body, style: AppTextStyles.inter(fontSize: 14, color: AppColors.textPrimary, height: 1.5)),
                if (sub != null) ...[
                  const SizedBox(height: 2),
                  Text(sub!, style: AppTextStyles.inter(fontSize: 12, color: AppColors.textSubtle)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── FAQ ───────────────────────────────────────────────────────────────────────

class _FAQSection extends StatelessWidget {
  final AppLocalizations l10n;
  const _FAQSection({required this.l10n});

  static const _faqs = [
    (
      q: 'Do I need my exact birth time?',
      a: 'An accurate birth time (within 5 minutes) is essential for most readings as it determines your Ascendant, houses, and current dasha period. If you do not know your birth time, a Prashna Kundli or Numerology session may be more suitable.'
    ),
    (
      q: 'Are sessions available online?',
      a: 'Yes. All consultation types are available via secure video call (Zoom or Google Meet). Online sessions are identical in quality to in-person ones. The time zone can be adjusted for international clients.'
    ),
    (
      q: 'How far in advance should I book?',
      a: 'Slots typically fill 10–14 days in advance. For urgent Prashna Kundli sessions, same-week availability is sometimes possible. Contact via WhatsApp for the earliest available slot.'
    ),
    (
      q: 'What language are sessions conducted in?',
      a: 'Sessions are available in Hindi and English. You can switch languages mid-session if needed. The written report (PDF) is provided in your chosen language.'
    ),
    (
      q: 'Is the information shared in sessions confidential?',
      a: 'Absolutely. All consultation details are held in strict confidence and never shared. Client privacy is a core principle of this practice.'
    ),
    (
      q: 'Can you provide remedies without an in-person visit?',
      a: 'Yes. All remedies — mantras, yantras, daan, and gemstone prescriptions — can be provided online with full written instructions. Physical puja services at the Rohini, Delhi centre are also available for local clients.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return Container(
      width: double.infinity,
      color: AppColors.surface,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 80 : 24,
              vertical: 80,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 24, height: 1, color: AppColors.gold),
                    const SizedBox(width: 12),
                    Text(l10n.contactFaqLabel, style: AppTextStyles.cinzel(fontSize: 10, letterSpacing: 3.5)),
                    const SizedBox(width: 12),
                    Container(width: 24, height: 1, color: AppColors.gold),
                  ],
                ),
                const SizedBox(height: 16),
                Text(l10n.contactFaqTitle, style: AppTextStyles.cormorant(fontSize: 48, weight: FontWeight.w300)),
                const SizedBox(height: 48),
                ..._faqs.map((faq) => _FAQItem(q: faq.q, a: faq.a)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FAQItem extends StatefulWidget {
  final String q;
  final String a;
  const _FAQItem({required this.q, required this.a});

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
        color: _open ? AppColors.gold.withValues(alpha: 0.04) : AppColors.background,
        border: Border.all(color: _open ? AppColors.gold.withValues(alpha: 0.4) : AppColors.borderGold, width: 0.5),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.q,
                      style: AppTextStyles.inter(
                        fontSize: 14,
                        color: _open ? AppColors.gold : AppColors.textPrimary,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  AnimatedRotation(
                    turns: _open ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.add, color: AppColors.gold, size: 18),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _open
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                    child: Text(
                      widget.a,
                      style: AppTextStyles.inter(fontSize: 14, color: AppColors.textMuted, height: 1.75),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
