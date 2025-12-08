import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waven/common/imageconstant.dart';

class Appbars extends StatelessWidget{
  final bool isloginpage;
  const Appbars({super.key, required this.isloginpage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(ImagesPath.logotekspng,),
            isloginpage? ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00A76F)
              ),
              onPressed: (){
                context.go("/signup");
              }, child: Text("Signup",style: GoogleFonts.robotoFlex(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),)):ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00A76F)
              ),
              onPressed: (){
                context.go("/login");
              }, child: Text("Login",style: GoogleFonts.robotoFlex(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),))
          ],
        )
      ),
    );
  }
}