import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';

class GlassCard extends ConsumerWidget {
  final Widget child;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? blur;
  final Color? color;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.blur,
    this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final intensity = settings.glassIntensity;
    
    final radius = borderRadius ?? settings.borderRadius;
    final blurAmount = (blur ?? 10.0) * intensity;
    final opacity = 0.05 + (0.15 * intensity);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: (color ?? Colors.white).withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: Colors.white.withValues(alpha: opacity * 2),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
