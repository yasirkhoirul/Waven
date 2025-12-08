import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:waven/common/color.dart';

class CustomCarousel extends StatefulWidget {
  final List<Widget> items;
  final double height;
  final bool autoPlay;

  const CustomCarousel({
    super.key,
    required this.items,
    this.height = 300,
    this.autoPlay = true,
  });

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider(
          items: widget.items,
          options: CarouselOptions(
            height: widget.height,
            autoPlay: widget.autoPlay,
            enlargeCenterPage: true,
            viewportFraction: 0.70,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),

        const SizedBox(height: 10),

        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.items.asMap().entries.map((entry) {
            bool isActive = _currentIndex == entry.key;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isActive ? 20 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isActive ? ColorTema.accentColor : Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
