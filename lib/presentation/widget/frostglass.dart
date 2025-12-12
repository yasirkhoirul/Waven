import 'dart:ui';
import 'package:flutter/material.dart';

class FrostGlassAnimated extends StatefulWidget {
  final double width;
  final double? height ;
  final Widget child;
  final double blur;
  final int maxAlpha; // nilai alpha akhir untuk gradient
  final int maxAlphaBorder; // alpha akhir untuk border
  final BorderRadius borderRadius;
  final Duration duration;

  const FrostGlassAnimated({
    super.key,
    required this.width,
    this.height,
    required this.child,
    this.blur = 10.0,
    this.maxAlpha = 60,
    this.maxAlphaBorder = 40,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  State<FrostGlassAnimated> createState() => _FrostGlassAnimatedState();
}

class _FrostGlassAnimatedState extends State<FrostGlassAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> borderAlphaAnim;
  late Animation<double> gradientAlphaAnim;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    borderAlphaAnim = Tween<double>(begin: 0, end: widget.maxAlphaBorder.toDouble())
        .animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    gradientAlphaAnim =
        Tween<double>(begin: 0, end: widget.maxAlpha.toDouble()).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, _) {
        return ClipRRect(
          borderRadius: widget.borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: widget.blur,
              sigmaY: widget.blur,
            ),
            child: Container(
              width: widget.width,
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF999999).withAlpha(gradientAlphaAnim.value.toInt()),
                    Colors.white.withAlpha(gradientAlphaAnim.value.toInt()),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                border: Border.all(
                  color: Colors.white
                      .withAlpha(borderAlphaAnim.value.toInt()),
                  width: 1.3,
                ),
              ),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
