import 'dart:math' as math;
import 'package:flutter/material.dart';

const double kContentWidth = 1200;
const double kPagePadding = 24;

double sidePaddingFor(double width) {
  return math.max(kPagePadding, (width - kContentWidth) / 2);
}

class PageWidth extends StatelessWidget {
  const PageWidth({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: kContentWidth + kPagePadding * 2),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPagePadding).add(padding),
          child: child,
        ),
      ),
    );
  }
}

