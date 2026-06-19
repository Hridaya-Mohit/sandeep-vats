import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class NavBar extends ConsumerStatefulWidget {
  final bool isScrolled;

  const NavBar({
    super.key,
    required this.isScrolled,
  });

  @override
  ConsumerState<NavBar> createState() => _NavBarState();
}

class _NavBarState extends ConsumerState<NavBar> {
  bool _menuOpen = false;

  @override
  Widget build(BuildContext context) {
    final l10n      = ref.watch(localizationsProvider);
    final width     = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    final hasBg     = widget.isScrolled || _menuOpen;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: hasBg
            ? AppColors.background.withValues(alpha: 0.96)
            : Colors.transparent,
        border: hasBg
            ? const Border(bottom: BorderSide(color: AppColors.borderGold, width: 0.5))
            : null,
        boxShadow: widget.isScrolled
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 30, offset: const Offset(0, 4))]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Top bar (always visible)
          SizedBox(
            height: 72,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 48 : 20),
              child: Row(
                children: [
                  _Logo(onTap: () => context.go('/')),
                  const Spacer(),
                  if (isDesktop) ...[
                    _NavLinks(l10n: l10n),
                    const SizedBox(width: 28),
                    const _LangToggle(),
                    const SizedBox(width: 20),
                    _BookCTA(label: l10n.navBookNow),
                  ] else ...[
                    const _LangToggle(),
                    const SizedBox(width: 16),
                    _HamburgerButton(
                      isOpen: _menuOpen,
                      onTap: () => setState(() => _menuOpen = !_menuOpen),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ── Mobile dropdown (slides in/out)
          if (!isDesktop)
            ClipRect(
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                heightFactor: _menuOpen ? 1.0 : 0.0,
                child: _MobileMenu(
                  l10n: l10n,
                  onNavTap: () => setState(() => _menuOpen = false),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Logo ──────────────────────────────────────────────────────────────────────

class _Logo extends StatelessWidget {
  final VoidCallback onTap;
  const _Logo({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('✦', style: TextStyle(color: AppColors.gold, fontSize: 16)),
            const SizedBox(width: 10),
            Text('Sandeep Vats', style: AppTextStyles.cinzel(fontSize: 15, letterSpacing: 2.5)),
          ],
        ),
      ),
    );
  }
}

// ── Desktop Nav Links ─────────────────────────────────────────────────────────

class _NavLinks extends StatelessWidget {
  final AppLocalizations l10n;

  const _NavLinks({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).matchedLocation;
    final links = [
      (l10n.navHome,         '/'),
      (l10n.navAbout,        '/about'),
      (l10n.navServices,     '/services'),
      (l10n.navTestimonials, '/testimonials'),
      (l10n.navContact,      '/contact'),
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: links
          .map((e) => _NavLinkItem(
                label: e.$1,
                route: e.$2,
                isActive: currentPath == e.$2,
              ))
          .toList(),
    );
  }
}

class _NavLinkItem extends StatefulWidget {
  final String label;
  final String route;
  final bool isActive;

  const _NavLinkItem({required this.label, required this.route, required this.isActive});

  @override
  State<_NavLinkItem> createState() => _NavLinkItemState();
}

class _NavLinkItemState extends State<_NavLinkItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final highlight = _hovered || widget.isActive;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(widget.route),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: AppTextStyles.inter(
                  fontSize: 13,
                  color: highlight ? AppColors.gold : AppColors.textPrimary,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 1,
                width: highlight ? 18 : 0,
                color: AppColors.gold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Language Toggle ───────────────────────────────────────────────────────────

class _LangToggle extends ConsumerWidget {
  const _LangToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderGold, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LangPill(
            label: 'EN',
            isActive: locale == AppLocale.en,
            onTap: () => ref.read(localeProvider.notifier).state = AppLocale.en,
          ),
          _LangPill(
            label: 'हि',
            isActive: locale == AppLocale.hi,
            onTap: () => ref.read(localeProvider.notifier).state = AppLocale.hi,
          ),
        ],
      ),
    );
  }
}

class _LangPill extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _LangPill({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? AppColors.gold : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: AppTextStyles.cinzel(
              fontSize: 10,
              color: isActive ? AppColors.background : AppColors.textMuted,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Book CTA ──────────────────────────────────────────────────────────────────

class _BookCTA extends StatefulWidget {
  final String label;
  const _BookCTA({required this.label});

  @override
  State<_BookCTA> createState() => _BookCTAState();
}

class _BookCTAState extends State<_BookCTA> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/contact'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.gold : Colors.transparent,
            border: Border.all(color: AppColors.gold, width: 1),
            borderRadius: BorderRadius.circular(4),
            boxShadow: _hovered
                ? [BoxShadow(color: AppColors.gold.withValues(alpha: 0.25), blurRadius: 16)]
                : null,
          ),
          child: Text(
            widget.label,
            style: AppTextStyles.cinzel(
              fontSize: 10,
              color: _hovered ? AppColors.background : AppColors.gold,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Hamburger Button ──────────────────────────────────────────────────────────

class _HamburgerButton extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onTap;

  const _HamburgerButton({required this.isOpen, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isOpen ? Icons.close_rounded : Icons.menu_rounded,
            key: ValueKey(isOpen),
            color: AppColors.gold,
            size: 26,
          ),
        ),
      ),
    );
  }
}

// ── Mobile Menu ───────────────────────────────────────────────────────────────

class _MobileMenu extends StatelessWidget {
  final AppLocalizations l10n;
  final VoidCallback onNavTap;

  const _MobileMenu({required this.l10n, required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    final links = [
      (l10n.navHome,         '/'),
      (l10n.navAbout,        '/about'),
      (l10n.navServices,     '/services'),
      (l10n.navTestimonials, '/testimonials'),
      (l10n.navContact,      '/contact'),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderGold, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...links.map((e) => _MobileNavItem(
                label: e.$1,
                onTap: () {
                  onNavTap();
                  context.go(e.$2);
                },
              )),
          const SizedBox(height: 12),
          const Divider(color: AppColors.borderGold, thickness: 0.5, height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              const _LangToggle(),
              const Spacer(),
              _BookCTA(label: l10n.navBookNow),
            ],
          ),
        ],
      ),
    );
  }
}

class _MobileNavItem extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _MobileNavItem({required this.label, required this.onTap});

  @override
  State<_MobileNavItem> createState() => _MobileNavItemState();
}

class _MobileNavItemState extends State<_MobileNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _hovered ? 14 : 0,
                height: 1,
                color: AppColors.gold,
                margin: EdgeInsets.only(right: _hovered ? 10 : 0),
              ),
              Text(
                widget.label,
                style: AppTextStyles.inter(
                  fontSize: 15,
                  color: _hovered ? AppColors.gold : AppColors.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
