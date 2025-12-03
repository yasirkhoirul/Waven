import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waven/common/imageconstant.dart';

class HoverLiftButton extends StatefulWidget {
  const HoverLiftButton({super.key, required this.onClik, required this.imagepath, required this.nama, required this.height, required this.width});
  final Function() onClik;
  final String imagepath;
  final String nama;
  final double height;
  final double width;

  @override
  State<HoverLiftButton> createState() => _HoverLiftButtonState();
}

class _HoverLiftButtonState extends State<HoverLiftButton> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(
          0,
          isHover ? -8 : 0, // naik 8px saat hover
          0,
        )..scale(isHover ? 1.04 : 1.0), // sedikit membesar
        curve: Curves.easeOut,
        child: InkWell(
          onTap: widget.onClik,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: isHover
                  ? [
                      BoxShadow(
                        blurRadius: 25,
                        offset: Offset(0, 12),
                        color: Colors.white.withAlpha(100),
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    widget.imagepath,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withAlpha(128),
                  ),
                ),
                Center(
                  child: Text(
                    widget.nama,
                    style: GoogleFonts.robotoFlex(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

