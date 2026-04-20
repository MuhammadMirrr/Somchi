import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/number_formatter.dart';

/// Animated rate counter that smoothly transitions between old and new values.
///
/// When [value] changes, the displayed number counts from the previous value
/// to the new value with an easeOutCubic curve (Revolut-style effect).
///
/// When [showPulse] is true, a brief colored highlight appears behind the
/// rate text on value changes (not on first build).
class AnimatedRate extends StatefulWidget {
  final double value;
  final TextStyle? style;
  final bool showPulse;
  final bool isPositive;

  const AnimatedRate({
    super.key,
    required this.value,
    this.style,
    this.showPulse = false,
    this.isPositive = true,
  });

  @override
  State<AnimatedRate> createState() => _AnimatedRateState();
}

class _AnimatedRateState extends State<AnimatedRate>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  bool _isFirstBuild = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void didUpdateWidget(AnimatedRate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !_isFirstBuild && widget.showPulse) {
      // Skip pulse animation when reduce motion is enabled;
      // context is available because didUpdateWidget runs after the widget
      // is attached to the element tree.
      final reduceMotion = MediaQuery.of(context).disableAnimations;
      if (!reduceMotion) {
        _pulseController.forward(from: 0.0);
      }
    }
    _isFirstBuild = false;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    final Widget rateWidget;
    if (reduceMotion) {
      rateWidget = Text(
        NumberFormatter.formatRate(widget.value),
        style: widget.style,
        maxLines: 1,
      );
    } else {
      rateWidget = TweenAnimationBuilder<double>(
        tween: Tween<double>(end: widget.value),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        builder: (context, animatedValue, _) {
          return Text(
            NumberFormatter.formatRate(animatedValue),
            style: widget.style,
            maxLines: 1,
          );
        },
      );
    }

    if (!widget.showPulse) return rateWidget;

    if (reduceMotion) return rateWidget;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        if (!_pulseController.isAnimating) return child!;

        final opacity = (1.0 - _pulseController.value) * 0.12;
        final color =
            widget.isPositive ? AppColors.positive : AppColors.negative;
        return Container(
          decoration: BoxDecoration(
            color: color.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(AppConstants.radiusXS),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: child,
        );
      },
      child: rateWidget,
    );
  }
}
