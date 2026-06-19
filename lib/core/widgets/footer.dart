import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF07070C),
        border: Border(top: BorderSide(color: AppColors.borderGold, width: 0.5)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 80 : 24,
              vertical: 56,
            ),
            child: isDesktop ? _DesktopFooter() : _MobileFooter(),
          ),
          const _BottomBar(),
        ],
      ),
    );
  }
}

class _DesktopFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _BrandColumn()),
        const SizedBox(width: 64),
        Expanded(flex: 2, child: _LinksColumn(title: 'Navigation', links: _navLinks)),
        const SizedBox(width: 32),
        Expanded(flex: 2, child: _LinksColumn(title: 'Services', links: _serviceLinks)),
        const SizedBox(width: 32),
        Expanded(flex: 2, child: _ContactColumn()),
      ],
    );
  }
}

class _MobileFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BrandColumn(),
        const SizedBox(height: 40),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _LinksColumn(title: 'Navigation', links: _navLinks)),
            const SizedBox(width: 24),
            Expanded(child: _LinksColumn(title: 'Services', links: _serviceLinks)),
          ],
        ),
        const SizedBox(height: 40),
        _ContactColumn(),
      ],
    );
  }
}

class _BrandColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('✦', style: TextStyle(color: AppColors.gold, fontSize: 18)),
            const SizedBox(width: 10),
            Text('Sandeep Vats', style: AppTextStyles.cinzel(fontSize: 15, letterSpacing: 2.5)),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Jyotish Acharya · Vedic Astrologer',
          style: AppTextStyles.inter(fontSize: 12, color: AppColors.gold.withValues(alpha: 0.7), letterSpacing: 0.5),
        ),
        const SizedBox(height: 16),
        Text(
          'Mata Bhimeshwari Devi Jyotish Kendra\nIlluminating lives through the ancient\nscience of Vedic astrology since 2009.',
          style: AppTextStyles.inter(fontSize: 13, color: AppColors.textSubtle, height: 1.7),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SocialBtn(icon: Icons.camera_alt_outlined, label: 'Instagram'),
            const SizedBox(width: 12),
            _SocialBtn(icon: Icons.phone_outlined, label: 'WhatsApp'),
            const SizedBox(width: 12),
            _SocialBtn(icon: Icons.mail_outlined, label: 'Email'),
          ],
        ),
      ],
    );
  }
}

class _SocialBtn extends StatefulWidget {
  final IconData icon;
  final String label;
  const _SocialBtn({required this.icon, required this.label});

  @override
  State<_SocialBtn> createState() => _SocialBtnState();
}

class _SocialBtnState extends State<_SocialBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: _hovered ? AppColors.gold : AppColors.borderGold,
            width: 1,
          ),
          color: _hovered ? AppColors.gold.withValues(alpha: 0.1) : Colors.transparent,
        ),
        child: Icon(widget.icon, size: 15, color: _hovered ? AppColors.gold : AppColors.textSubtle),
      ),
    );
  }
}

const _navLinks = [
  ('Home', '/'),
  ('About', '/about'),
  ('Services', '/services'),
  ('Testimonials', '/testimonials'),
  ('Contact', '/contact'),
];

const _serviceLinks = [
  ('Kundli Analysis', '/services'),
  ('Kundli Milan', '/services'),
  ('Vastu Shastra', '/services'),
  ('Numerology', '/services'),
  ('Career & Finance', '/services'),
  ('Gemstone Consult', '/services'),
];

class _LinksColumn extends StatelessWidget {
  final String title;
  final List<(String, String)> links;

  const _LinksColumn({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.cinzel(fontSize: 10, letterSpacing: 3)),
        const SizedBox(height: 4),
        Container(width: 24, height: 1, color: AppColors.gold),
        const SizedBox(height: 20),
        ...links.map((e) => _FooterLink(label: e.$1, route: e.$2)),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;
  final String route;
  const _FooterLink({required this.label, required this.route});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: AppTextStyles.inter(
              fontSize: 13,
              color: _hovered ? AppColors.gold : AppColors.textSubtle,
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}

class _ContactColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact', style: AppTextStyles.cinzel(fontSize: 10, letterSpacing: 3)),
        const SizedBox(height: 4),
        Container(width: 24, height: 1, color: AppColors.gold),
        const SizedBox(height: 20),
        _ContactItem(icon: Icons.location_on_outlined, text: 'Plot No. 76, Pocket-1, Sector-24\nNear D.D.A. Market, Rohini, Delhi'),
        const SizedBox(height: 14),
        _ContactItem(icon: Icons.phone_outlined, text: '+91 98915 86497'),
        const SizedBox(height: 14),
        _ContactItem(icon: Icons.mail_outlined, text: 'sandeepvats.jyotish@gmail.com'),
        const SizedBox(height: 14),
        _ContactItem(icon: Icons.access_time_outlined, text: 'Mon–Sat · 10 AM – 7 PM IST'),
      ],
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ContactItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.gold),
        const SizedBox(width: 10),
        Flexible(
          child: Text(text, style: AppTextStyles.inter(fontSize: 13, color: AppColors.textSubtle, height: 1.6)),
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderGold, width: 0.5)),
      ),
      child: isDesktop
          ? Row(
              children: [
                Text(
                  '© 2026 Sandeep Vats. All rights reserved.',
                  style: AppTextStyles.inter(fontSize: 12, color: AppColors.textSubtle),
                ),
                const Spacer(),
                Text(
                  'Crafted with devotion ✦',
                  style: AppTextStyles.inter(fontSize: 12, color: AppColors.textSubtle),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '© 2026 Sandeep Vats. All rights reserved.',
                  style: AppTextStyles.inter(fontSize: 11, color: AppColors.textSubtle),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Crafted with devotion ✦',
                  style: AppTextStyles.inter(fontSize: 11, color: AppColors.textSubtle),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
    );
  }
}
