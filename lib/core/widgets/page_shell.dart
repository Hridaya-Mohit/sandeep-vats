import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'footer.dart';
import 'nav_bar.dart';

/// Shared wrapper for all non-home pages.
/// Provides scroll controller, NavBar, and Footer.
class PageShell extends StatefulWidget {
  final Widget child;
  const PageShell({super.key, required this.child});

  @override
  State<PageShell> createState() => _PageShellState();
}

class _PageShellState extends State<PageShell> {
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
            child: Column(
              children: [
                const SizedBox(height: 72),
                widget.child,
                const Footer(),
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
