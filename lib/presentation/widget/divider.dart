import 'package:flutter/material.dart';

class AnimatedDividerCurve extends StatefulWidget {
  final Color color;
  final double height;
  final Duration duration;
  final Curve curve;

  const AnimatedDividerCurve({
    super.key,
    this.color = Colors.black,
    this.height = 2,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeInOut,
  });

  @override
  State<AnimatedDividerCurve> createState() => _AnimatedDividerCurveState();
}

class _AnimatedDividerCurveState extends State<AnimatedDividerCurve> {
  double _widthFactor = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _widthFactor = 1; // Full width animation
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: _widthFactor),
      duration: widget.duration,
      curve: widget.curve,
      builder: (context, value, child) {
        return FractionallySizedBox(
          widthFactor: value,
          alignment: Alignment.centerLeft,
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(widget.height),
            ),
          ),
        );
      },
    );
  }
}
