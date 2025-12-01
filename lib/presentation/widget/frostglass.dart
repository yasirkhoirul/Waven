import 'dart:ui';
import 'package:flutter/material.dart';

class FrostGlass extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final double blur;
  final int opacity;
  final BorderRadius borderRadius;

  const FrostGlass({
    super.key,
    required this.width,
    required this.height,
    required this.child,
    this.blur = 20.0,
    this.opacity = 50,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              colors: [
                Color(0xFF999999).withAlpha(opacity),
                Colors.white.withAlpha(opacity),
              ],
              begin: AlignmentGeometry.bottomCenter,
              end: AlignmentGeometry.topCenter,
            ), // efek kaca
            border: Border.all(color: Colors.white.withAlpha(40), width: 1.2),
          ),
          child: child,
        ),
      ),
    );
  }
}
