import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waven/common/imageconstant.dart';

class AppbarsUser extends StatelessWidget {
  final VoidCallback? onmenupress;
  final Function(int) onpress;
  final bool alreadylogin;
  const AppbarsUser({super.key, required this.alreadylogin, required this.onpress, this.onmenupress});

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width<800;
    return SizedBox(
      height: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(ImagesPath.logotekspng),
            !isSmall? Row(
              children: [
                TextButton(
                        onPressed: () {
                          onpress(0);
                        },
                        child: Text("Home",style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontSize: 14
                        ),),
                      ),
                      TextButton(
                        onPressed: () {
                          // onpress(1);
                        },
                        child: Text("package",style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontSize: 14
                        ),),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text("Gallery",style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontSize: 14
                        ),),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text("About Us",style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontSize: 14
                        ),),
                      ),
                alreadylogin
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00A76F),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Logout",
                      style: GoogleFonts.robotoFlex(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00A76F),
                    ),
                    onPressed: () {
                      
                    },
                    child: Text(
                      "Login",
                      style: GoogleFonts.robotoFlex(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ):IconButton(onPressed: onmenupress, icon: Icon(Icons.menu,color: Colors.white,)),
          ]
        )
      ),
    );
  }
}
