import 'package:flutter/material.dart';

/// Centers content within a max-width of 1200px with consistent horizontal padding.
class SectionWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const SectionWrapper({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 48, vertical: 80),
          child: child,
        ),
      ),
    );
  }
}
