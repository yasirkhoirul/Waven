import 'package:flutter/material.dart';

class FadeInUpText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final Duration delay;
  final double offsetY;
  final TextAlign? alig;

  const FadeInUpText({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.alig,
    this.offsetY = 20.0, // jarak awal dari bawah
  });

  @override
  State<FadeInUpText> createState() => _FadeInUpTextState();
}

class _FadeInUpTextState extends State<FadeInUpText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<double> _offset;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _offset = Tween<double>(begin: widget.offsetY, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () => _controller.forward());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: Offset(0, _offset.value),
            child: child,
          ),
        );
      },
      child: Text(widget.text, style: widget.style,textAlign: widget.alig,),
    );
  }
}
