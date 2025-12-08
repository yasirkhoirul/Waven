import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyLottie extends StatefulWidget {
  final String aset;
  const MyLottie({super.key, required this.aset});
  @override
  _MyLottieState createState() => _MyLottieState();
}

class _MyLottieState extends State<MyLottie> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
          widget.aset,
          controller: _controller,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..repeat(); // bisa .forward(), .stop(), dll
          },
        );
  }
}
