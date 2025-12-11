import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/web.dart';
import 'package:waven/common/imageconstant.dart';
import 'package:waven/presentation/cubit/tokenauth_cubit.dart';

class AppbarsUser extends StatelessWidget {
  final VoidCallback? onmenupress;
  final Function(int) onpress;
  const AppbarsUser({super.key, required this.onpress, this.onmenupress});

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 800;
    return SizedBox(
      height: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(ImagesPath.logotekspng),
            !isSmall
                ? Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          onpress(0);
                        },
                        child: Text(
                          "Home",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w100,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          onpress(1);
                        },
                        child: Text(
                          "package",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w100,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          onpress(2);
                        },
                        child: Text(
                          "Gallery",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w100,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.goNamed('profile');
                        },
                        child: Text(
                          "Profile",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w100,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      BlocConsumer<TokenauthCubit, TokenauthState>(
                        listener: (context, state) {
                          
                        },
                        builder: (context, state) {
                          if (state.tokens != null) {
                            Logger().d(state.tokens);
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF00A76F),
                              ),
                              onPressed: () {
                                context.read<TokenauthCubit>().onLogout();
                              },
                              child: Text(
                                "Logout",
                                style: GoogleFonts.robotoFlex(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          } else {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF00A76F),
                              ),
                              onPressed: () {
                                context.go('/login');
                              },
                              child: Text(
                                "Login",
                                style: GoogleFonts.robotoFlex(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  )
                : IconButton(
                    onPressed: onmenupress,
                    icon: Icon(Icons.menu, color: Colors.white),
                  ),
          ],
        ),
      ),
    );
  }
}
