import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waven/common/imageconstant.dart';
import 'package:waven/presentation/widget/button.dart';

class Appbars extends StatelessWidget {
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
            InkWell(
              onTap: () => context.go('/home'),
              child: Image.asset(ImagesPath.logotekspng),
            ),
            isloginpage
                ? LWebButton(
                    label: "Signup",
                    onPressed: () {
                      context.go("/signup");
                    },
                  )
                : LWebButton(
                    label: "Login",
                    onPressed: () {
                      context.go("/login");
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
