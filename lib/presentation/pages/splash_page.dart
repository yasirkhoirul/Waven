import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:waven/common/imageconstant.dart';
import 'package:waven/presentation/cubit/asset_loader_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Setup fade animation
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // Start preloading assets
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) {
        _fadeController.forward();
        context.read<AssetLoaderCubit>().preloadAssets(context);
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      body: BlocListener<AssetLoaderCubit, AssetLoaderState>(
        listener: (context, state) {
          if (state is AssetLoaderLoaded) {
            // Navigate to home after assets are loaded
            Future.delayed(Duration(milliseconds: 300), () {
              if (mounted) {
                context.go('/home');
              }
            });
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              // Logo/Title
              Image.asset(
                ImagesPath.logotekspng,
                height: 120,
              ),
              SizedBox(height: 80),
              // Fade in SVG animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox(
                  height: 120,
                  width: 120,
                  child: SvgPicture.asset(ImagesPath.logoteks),
                ),
              ),
              SizedBox(height: 40),
              // Loading text
              BlocBuilder<AssetLoaderCubit, AssetLoaderState>(
                builder: (context, state) {
                  if (state is AssetLoaderError) {
                    return Column(
                      children: [
                        Text(
                          'Failed to load',
                          style: GoogleFonts.robotoFlex(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.robotoFlex(
                            color: Colors.red.shade300,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  }
                  return Text(
                    'Loading Assets...',
                    style: GoogleFonts.robotoFlex(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
              Spacer(),
              // Version or footer
              Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Text(
                  'Waven',
                  style: GoogleFonts.robotoFlex(
                    color: Colors.white38,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
