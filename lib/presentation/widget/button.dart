import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waven/common/color.dart';

class LMobileButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  const LMobileButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorTema.accentColor,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Row(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 30, color: Colors.white),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: GoogleFonts.robotoFlex(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class LWebButton extends StatelessWidget {
  final Color? backgroundColor;
  final String label;
  final Widget? widge;
  final VoidCallback? onPressed;
  final IconData? icon;
  const LWebButton({super.key, required this.label, this.onPressed, this.icon, this.widge,this.backgroundColor});

  @override
  Widget build(BuildContext context) {
     
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(0,40),
        maximumSize: Size(200, 60),
        backgroundColor: backgroundColor?? ColorTema.accentColor,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Row(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: Colors.white),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.robotoFlex(
                color: Colors.white,
                fontSize: 15, // 20% smaller than 16 ~ 15
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if(widge!=null)...[
            widge!
          ]
        ],
      ),
    );
  }
}
class MButtonWeb extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  const MButtonWeb({super.key, required this.label, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(0, 36),
        backgroundColor: ColorTema.accentColor,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: Colors.white),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: GoogleFonts.robotoFlex(
              color: Colors.white,
              fontSize: 12, // 20% smaller than 16 ~ 15
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}


