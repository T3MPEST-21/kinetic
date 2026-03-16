import 'package:flutter/material.dart';

class BackgroundWrapper extends StatelessWidget {
  final Widget child;
  final String? assetPath;
  final double opacity;

  const BackgroundWrapper({
    super.key,
    required this.child,
    this.assetPath,
    this.opacity = 0.4,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Opacity(
            opacity: opacity,
            child: Image.asset(
              assetPath ?? 'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
